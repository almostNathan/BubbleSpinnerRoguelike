extends Node2D
class_name BallGridManager

const BALL_SIZE : int = 32
const GRID_SIZE_X : int = 40
const GRID_SIZE_Y : int = 20
const RELATIVE_UP_LEFT : Vector2i = Vector2i(-1, -1)
const RELATIVE_UP_RIGHT : Vector2i = Vector2i(1, -1)
const RELATIVE_RIGHT : Vector2i = Vector2i(2, 0)
const RELATIVE_DOWN_RIGHT : Vector2i = Vector2i(1, 1)
const RELATIVE_DOWN_LEFT : Vector2i = Vector2i(-1, 1)
const RELATIVE_LEFT : Vector2i = Vector2i(-2, 0)
const NEIGHBORS : Array[Vector2i] = [
		RELATIVE_RIGHT, RELATIVE_LEFT,
		RELATIVE_UP_RIGHT, RELATIVE_UP_LEFT,
		RELATIVE_DOWN_RIGHT, RELATIVE_DOWN_LEFT
]

var center_point : Vector2
var grid_slot_dict : Dictionary[Vector2i, BallGridSlot]
var shot_count = 0

@onready var start_point = $StartPoint

var ball_grid_slot_scene = preload("res://Scenes/ball_grid_slot.tscn")

func _ready() -> void:
	self.position = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)
	SignalHub.connect_ball_colliding(ball_collided)
	SignalHub.connect_ball_shot(ball_shot)

func ball_shot(shot_ball, launcher):
	shot_count += 1
	if shot_count % 10 == 0:
		await get_tree().create_timer(.2).timeout
		add_balls(10)

func ball_collided(shot_ball: BaseBall, collided_ball: BaseBall):
	shot_ball.reparent(self, true)

	var closest_position = grid_spot_closest_to_position(shot_ball.position)
	grid_slot_dict[closest_position].set_ball_in_slot(shot_ball)
	
	###This section determines rotation
	#Notes:
	# add weight value to balls that will affect this process, 
	# factoring in total weight of the current grid and the weight of the new ball
	var direction_to_center : Vector2 = shot_ball.global_position.direction_to(self.position)
	var force_angle : float = direction_to_center.angle_to(shot_ball.movement_direction)
	var force_value : float = shot_ball.speed / 1500
	var rotation_tween : Tween = self.create_tween()
	rotation_tween.set_trans(Tween.TRANS_QUART)
	rotation_tween.set_ease(Tween.EASE_OUT)
	#calculates the difference in angle of shot ball and the angle to the center point.
	#Force is greatest when they are at 90/270 degrees and least at 0/180 -> sin
	rotation_tween.tween_property(self, 'rotation', self.rotation + (-sin(force_angle) * force_value), 1)
	
	clear_slots(get_connected_group(closest_position))

	update_available_positions()
	delete_islands()

func grid_spot_closest_to_position(from_position : Vector2):
		# find nearest available position to shot_ball
	var closest_position : Vector2i = Vector2i(0,0)
	var available_slots = get_available_slots()
	for i in range(len(available_slots)):
		if i == 0:
			closest_position = available_slots[i] 
		# determine which slot is the closest to the ball.
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
					x_offset =  x * BALL_SIZE / 2
				var new_relative_position = Vector2(x + x_offset  , y * (BALL_SIZE/2 * sqrt(3)))
				var new_ball_grid_slot : BallGridSlot = ball_grid_slot_scene.instantiate()
				new_ball_grid_slot.setup(Vector2i(x,y), new_relative_position)
				self.add_child(new_ball_grid_slot)
				grid_slot_dict[Vector2i(x,y)] = new_ball_grid_slot

	grid_slot_dict[Vector2i(0,0)].set_ball_in_slot(start_point)
	update_available_positions()
	add_balls(40)

func add_balls(num_balls : int):
	##randomly shoot balls towards the center.
	#TODO: create globals for possible ball types
	var types = [
			["red", Color(1.0, 0.0, 0.0,1)],
			["green", Color(0.0, 1.0, 0.0,1)],
			["blue", Color(0.0, 0.0, 1.0,1)],
			["yellow", Color(1.0, 1.0, 0.0,1)],
			["cyan", Color(0.0, 1.0, 1.0,1)],
			["purple", Color(1.0, 0.0, 1.0,1)],
		]
	for i in range(num_balls):
		var new_ball = preload("res://Scenes/base_ball.tscn").instantiate()
		var selected_type = types.pick_random()
		new_ball.add_type(selected_type[0], selected_type[1])
		new_ball.position = Vector2(300, 0).rotated(randf()*2*PI) + self.position
		new_ball.aim_at(self.global_position)
		self.add_sibling(new_ball)
		await get_tree().create_timer(.05).timeout


func get_available_slots() -> Array[Vector2i]:
	var available_slots = grid_slot_dict.keys().filter(func(key): return grid_slot_dict[key].is_available)
	return available_slots

func get_unavailable_slots() -> Array[Vector2i]:
	var unavailable_slots = grid_slot_dict.keys().filter(func(key): return !grid_slot_dict[key].is_available)
	return unavailable_slots

func get_slots_with_balls():
	var slots_with_balls = grid_slot_dict.keys().filter(func(key): return grid_slot_dict[key].has_ball())
	return slots_with_balls

func update_available_positions():
	var open_positions = grid_slot_dict.keys().filter(func(key): return !grid_slot_dict[key].has_ball())
	for open_position in open_positions:
		grid_slot_dict[open_position].make_unavailable()
	var slotted_positions = grid_slot_dict.keys().filter(func(key): return grid_slot_dict[key].has_ball())
	for slotted_position in slotted_positions:
		var adjacent_grid_slots = grid_slot_dict[slotted_position].get_adjacent_grid_positions()
		
		for adjacent_grid_slot in adjacent_grid_slots:
			grid_slot_dict[adjacent_grid_slot].make_available()

func clear_slots(slot_positions : Array[Vector2i]):
	for slot_position in slot_positions:
		grid_slot_dict[slot_position].clear_slot()

func delete_islands() -> void:
	var start_pos : Vector2i = Vector2i(0,0)

	var visited : Dictionary[Vector2i, bool] = {}
	# group -> matching ball slots
	var group : Array[Vector2i] = []
	var queue : Array[Vector2i] = [start_pos]

	while queue.size() > 0:
		var current = queue.pop_front()
		if visited.has(current):
			continue
		visited[current] = true
		if not grid_slot_dict.has(current):
			continue
		if grid_slot_dict[current].has_ball():
			group.append(current)
			for offset in NEIGHBORS:
				var neighbor = current + offset
				if not visited.has(neighbor): 
					queue.append(neighbor)

	var island_slots : Array[Vector2i] = get_slots_with_balls()
	for slot in group:
		island_slots.erase(slot)
	clear_slots(island_slots)

func get_connected_group(start_pos: Vector2i) -> Array[Vector2i]:
	if not grid_slot_dict.has(start_pos):
		return []

	var target_types = grid_slot_dict[start_pos].get_types()
	var visited : Dictionary[Vector2i, bool] = {}
	# group -> matching ball slots
	var group : Array[Vector2i] = []
	var queue : Array[Vector2i] = [start_pos]

	while queue.size() > 0:
		var current = queue.pop_front()

		if visited.has(current):
			continue
		visited[current] = true

		if not grid_slot_dict.has(current):
			continue
		#check if the current gridballslot has any matching types to the target.
		var has_type := func (x: String) -> bool:
			return target_types.has(x)
		if grid_slot_dict[current].get_types().any(has_type):
			group.append(current)

			for offset in NEIGHBORS:
				var neighbor = current + offset
				if not visited.has(neighbor): 
					queue.append(neighbor)
	var empty_return : Array[Vector2i] = []
	return group if group.size() >= 3 else empty_return
