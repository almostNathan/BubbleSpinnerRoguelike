extends Node2D
class_name BubbleGridManager


const BUBBLE_SIZE : int = 40
const GRID_SIZE_X : int = 40
const GRID_SIZE_Y : int = 20

var center_point : Vector2
var grid_slot_dict : Dictionary[Vector2i, BubbleGridSlot]
var shot_count : int = 0
var total_rotation : float = 0
var last_rotation_value : float = 0

@onready var start_point : StartPoint = $StartPoint

var score_number_scene : PackedScene = preload("res://Scenes/UI/score_number.tscn")
var bubble_grid_slot_scene : PackedScene = preload("res://Scenes/BubbleGrid/bubble_grid_slot.tscn")
var center_grid_slot_scene : PackedScene = preload("res://Scenes/BubbleGrid/center_bubble_grid_slot.tscn")

func _physics_process(_delta: float) -> void:
	var rotation_change = self.rotation - last_rotation_value
	SignalHub.emit_rotate_bubble_grid(self, rotation_change)
	last_rotation_value = self.rotation
	

func _ready() -> void:
	self.position = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)
	SignalHub.connect_bubble_colliding(bubble_collided)
	SignalHub.connect_bubble_shot(bubble_shot)
	SignalHub.connect_apply_effect_to_bubble_slot(apply_effect_to_bubble_slot)
	SignalHub.connect_bubble_destroyed(bubble_destroyed)

func apply_effect_to_bubble_slot(effect : BaseEffect, bubble_grid_coords : Vector2i):
	effect.apply_effect(grid_slot_dict[bubble_grid_coords])

func bubble_shot(_shot_bubble, _launcher):
	shot_count += 1
	if shot_count % 10 == 0:
		await get_tree().create_timer(.5).timeout
		#add_bubbles(10)

func set_children_scene_root(node):
	for child in node.get_children():
		set_children_scene_root(child)
		child.set_owner(get_tree().edited_scene_root)

func bubble_collided(shot_bubble: BaseBubble, collided_bubble: BaseBubble):
	shot_bubble.reparent(self)
	shot_bubble.set_owner(get_tree().edited_scene_root)
	set_children_scene_root(shot_bubble)
	
	var closest_position = grid_spot_closest_to_position(shot_bubble.position)
	grid_slot_dict[closest_position].set_bubble_in_slot(shot_bubble)
	rotate_bubble_grid(shot_bubble, collided_bubble)
	var connected_group_pos_array = get_connected_group_pos(closest_position)
	if len(connected_group_pos_array) != 0:
		score_and_clear(closest_position)
	update_available_positions()
	delete_islands()

func rotate_bubble_grid(shot_bubble : BaseBubble, _collided_bubble : BaseBubble):
	###This section determines rotation
	#Notes:
	# add weight value to bubbles that will affect this process, 
	# factoring in total weight of the current grid and the weight of the new bubble
	var direction_to_center : Vector2 = shot_bubble.global_position.direction_to(self.position)
	var force_angle : float = direction_to_center.angle_to(shot_bubble.movement_direction)
	var force_value : float = shot_bubble.speed / 1500 * shot_bubble.weight
	var rotation_value : float = (-sin(force_angle) * force_value)
	self.track_rotation(rotation_value)
	var rotation_tween : Tween = self.create_tween()
	rotation_tween.set_trans(Tween.TRANS_QUART)
	rotation_tween.set_ease(Tween.EASE_OUT)
	var rotation_duration : float = clamp((shot_bubble.weight - 1) / 2, 1, 3)
	#calculates the difference in angle of shot bubble and the angle to the center point.
	#Force is greatest when they are at 90/270 degrees and least at 0/180 -> sin
	rotation_tween.tween_property(self, 'rotation', self.rotation + rotation_value, rotation_duration)

func track_rotation(rotation_value : float):
	self.total_rotation += rotation_value
	
func score_and_clear(closest_position : Vector2i) -> void:
	var connected_group_pos = get_connected_group_pos(closest_position)
	var score = 0
	for bubble_pos in connected_group_pos:
		score += grid_slot_dict[bubble_pos].score_slot()
	
	var score_number :ScoreNumber = score_number_scene.instantiate()
	add_sibling(score_number)
	score_number.score_value = score
	SignalHub.emit_scoring_bubbles(score_number)
	score_number.animate(grid_slot_dict[closest_position].global_position)
	Hud.change_score(score_number.score_value)
	destroy_slots(connected_group_pos)


func grid_spot_closest_to_position(from_position : Vector2):
		# find nearest available position to shot_bubble
	var closest_position : Vector2i = Vector2i(0,0)
	var available_slots = get_available_slots()
	for i in range(len(available_slots)):
		if i == 0:
			closest_position = available_slots[i] 
		# determine which slot is the closest to the bubble.
		if from_position.distance_to(grid_slot_dict[available_slots[i]].get_current_position()) < from_position.distance_to(grid_slot_dict[closest_position].get_current_position()):
			closest_position = available_slots[i]
	return closest_position


func set_up_grid_locations():
	#create a dictionary of 
	# x,y coords (positions in the grid) : Vector2 position in game
	var x_offset = 0
	for y in range(-GRID_SIZE_Y, GRID_SIZE_Y):
		for x in range(-GRID_SIZE_X,GRID_SIZE_X):
			if (x+y) % 2 == 0:
				if x == 0:
					x_offset = 0
				else:
					x_offset =  x * BUBBLE_SIZE / 2.0
				if x == 0 and y == 0:
					var new_relative_position = Vector2(x + x_offset  , y * (BUBBLE_SIZE/2.0 * sqrt(3)))
					var new_bubble_grid_slot : CenterBubbleGridSlot = center_grid_slot_scene.instantiate()
					new_bubble_grid_slot.setup(Vector2i(x,y), new_relative_position)
					self.add_child(new_bubble_grid_slot)
					grid_slot_dict[Vector2i(x,y)] = new_bubble_grid_slot
					grid_slot_dict[Vector2i(0,0)].set_bubble_in_slot(start_point)
				else:
					var new_relative_position = Vector2(x + x_offset  , y * (BUBBLE_SIZE/2.0 * sqrt(3)))
					var new_bubble_grid_slot : BubbleGridSlot = bubble_grid_slot_scene.instantiate()
					new_bubble_grid_slot.setup(Vector2i(x,y), new_relative_position)
					self.add_child(new_bubble_grid_slot)
					grid_slot_dict[Vector2i(x,y)] = new_bubble_grid_slot
	update_available_positions()
	add_bubbles(20)


func add_bubbles(num_bubbles : int):
	##randomly shoot bubbles towards the center.
	for i in range(num_bubbles):
		var new_bubble = preload("res://Scenes/base_bubble.tscn").instantiate()
		var new_type : String = BubbleTypes.types.keys().pick_random()
		new_bubble.add_type(new_type, BubbleTypes.types[new_type]['color'])
		new_bubble.position = Vector2(300, 0).rotated(randf()*2*PI) + self.position
		new_bubble.aim_at(self.global_position)
		self.add_sibling(new_bubble)
		await get_tree().create_timer(.05).timeout


func get_available_slots() -> Array[Vector2i]:
	var available_slots = grid_slot_dict.keys().filter(func(key): return grid_slot_dict[key].is_available)
	return available_slots


func get_unavailable_slots() -> Array[Vector2i]:
	var unavailable_slots = grid_slot_dict.keys().filter(func(key): return !grid_slot_dict[key].is_available)
	return unavailable_slots


func get_slots_with_bubbles():
	var slots_with_bubbles = grid_slot_dict.keys().filter(func(key): return grid_slot_dict[key].has_bubble())
	return slots_with_bubbles


func update_available_positions():
	var open_positions = grid_slot_dict.keys().filter(func(key): return !grid_slot_dict[key].has_bubble())
	for open_position in open_positions:
		grid_slot_dict[open_position].make_unavailable()
	var slotted_positions = grid_slot_dict.keys().filter(func(key): return grid_slot_dict[key].has_bubble())
	for slotted_position in slotted_positions:
		var adjacent_grid_slots = grid_slot_dict[slotted_position].get_adjacent_grid_positions()
		
		for adjacent_grid_slot in adjacent_grid_slots:
			grid_slot_dict[adjacent_grid_slot].make_available()


func clear_slots(slot_positions : Array[Vector2i]):
	for slot_position in slot_positions:
		grid_slot_dict[slot_position].clear_slot()

func destroy_slots(slot_positions : Array[Vector2i]):
	for slot_position in slot_positions:
		grid_slot_dict[slot_position].destroy_slot()

func delete_islands() -> void:
	var start_pos : Vector2i = Vector2i(0,0)

	var visited : Dictionary[Vector2i, bool] = {}
	# group -> matching bubble slots
	var group : Array[Vector2i] = []
	var queue : Array[Vector2i] = [start_pos]

	while queue.size() > 0:
		var current = queue.pop_front()
		if visited.has(current):
			continue
		visited[current] = true
		if not grid_slot_dict.has(current):
			continue
		if grid_slot_dict[current].has_bubble():
			group.append(current)
			for offset in Util.RELATIVE_POSITIONS_ARRAY:
				var neighbor = current + offset
				if not visited.has(neighbor): 
					queue.append(neighbor)

	var island_slots : Array[Vector2i] = get_slots_with_bubbles()
	for slot in group:
		island_slots.erase(slot)
	clear_slots(island_slots)

func bubble_destroyed(_destroyed_bubble : BaseBubble) -> void:
	delete_islands()

func get_connected_group_pos(start_pos: Vector2i) -> Array[Vector2i]:
	if not grid_slot_dict.has(start_pos):
		return []

	var target_types = grid_slot_dict[start_pos].get_types()
	var visited : Dictionary[Vector2i, bool] = {}
	# group -> matching bubble slots
	var group : Array[Vector2i] = []
	var queue : Array[Vector2i] = [start_pos]

	while queue.size() > 0:
		var current = queue.pop_front()

		if visited.has(current):
			continue
		visited[current] = true

		if not grid_slot_dict.has(current):
			continue
		#check if the current gridbubbleslot has any matching types to the target.
		var has_type := func (x: String) -> bool:
			return target_types.has(x)
		if grid_slot_dict[current].get_types().any(has_type):
			group.append(current)

			for offset in Util.RELATIVE_POSITIONS_ARRAY:
				var neighbor = current + offset
				if not visited.has(neighbor): 
					queue.append(neighbor)
	var empty_return : Array[Vector2i] = []
	return group if group.size() >= 3 else empty_return
