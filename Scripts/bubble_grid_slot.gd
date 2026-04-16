extends Node2D
class_name BubbleGridSlot


var grid_position : Vector2i
#var grid_rotation : float = 0
var relative_position : Vector2
var center_point : Vector2
var bubble_in_slot : BaseBubble
var is_active = true
var is_available = false
var types : Array[String] = []

func setup(new_grid_position, new_position) -> void:
	self.grid_position = new_grid_position
	self.position = new_position
	self.center_point = center_point
	$Label.text = str(self.grid_position).substr(1,str(self.grid_position).find(')')-1)
	
func get_current_position() -> Vector2:
	return self.position

func get_current_global_position() -> Vector2:
	var current_global_position = self.position + center_point
	#current_global_position.rotated(grid_rotation)
	return current_global_position

#func set_current_rotation(rotation_radians)-> void:
	#grid_rotation = rotation_radians

func update_bubble_position():
	bubble_in_slot.position = get_current_position()

func set_bubble_in_slot(new_bubble : BaseBubble):
	bubble_in_slot = new_bubble
	var bubble_position_tween = bubble_in_slot.create_tween()
	bubble_position_tween.set_ease(Tween.EASE_OUT)
	bubble_position_tween.tween_property(bubble_in_slot, 'position', get_current_position(), .01)
	#bubble_in_slot.position  = get_current_position()
	self.make_unavailable() 
	bubble_in_slot.set_slot(self)
	

func destroy_slot() -> void:
	if bubble_in_slot:
		bubble_in_slot.destroy() 
	bubble_in_slot = null
	self.make_available()

func get_adjacent_grid_positions() -> Array[Vector2i]:
	var adjacent_grid_positions_array : Array[Vector2i] = []
	for position_change in Util.RELATIVE_POSITIONS_ARRAY:
		adjacent_grid_positions_array.append(grid_position + position_change)
	return adjacent_grid_positions_array

func score_slot() -> int:
	if bubble_in_slot != null:
		return bubble_in_slot.score_bubble()
	else:
		return 0

func get_types() -> Array[String]:
	if bubble_in_slot:
		return types + bubble_in_slot.get_types()
	else:
		return types

func has_bubble() -> bool:
	if bubble_in_slot != null:
		return true
	else:
		return false

func make_active():
	is_active = true

func make_inactive():
	is_active = false

func make_available():
	if !bubble_in_slot:
		is_available = true
		is_active = true
		#$Sprite2D.visible = true
		#$Label.visible = true

func make_unavailable():
	is_available = false
	$Sprite2D.visible = false
	$Label.visible = false
	
