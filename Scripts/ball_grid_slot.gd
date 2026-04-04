extends Node2D
class_name BallGridSlot

const RELATIVE_UP_LEFT : Vector2i = Vector2i(-1, -1)
const RELATIVE_UP_RIGHT : Vector2i = Vector2i(1, -1)
const RELATIVE_RIGHT : Vector2i = Vector2i(2, 0)
const RELATIVE_DOWN_RIGHT : Vector2i = Vector2i(1, 1)
const RELATIVE_DOWN_LEFT : Vector2i = Vector2i(-1, 1)
const RELATIVE_LEFT : Vector2i = Vector2i(-2, 0)

var relative_positions_array : Array[Vector2i] = [RELATIVE_RIGHT, RELATIVE_LEFT, RELATIVE_UP_RIGHT, RELATIVE_UP_LEFT, RELATIVE_DOWN_RIGHT, RELATIVE_DOWN_LEFT]

var grid_position : Vector2i
#var grid_rotation : float = 0
var relative_position : Vector2
var center_point : Vector2
var ball_in_slot : BaseBall
var is_active = true
var is_available = false
var types : Array[String] = []

func setup(grid_position, new_position) -> void:
	self.grid_position = grid_position
	self.position = new_position
	self.center_point = center_point
	$Label.text = str(grid_position).substr(1,str(grid_position).find(')')-1)
	
func get_current_position() -> Vector2:
	return position

func get_current_global_position() -> Vector2:
	var current_global_position = position + center_point
	#current_global_position.rotated(grid_rotation)
	return current_global_position

#func set_current_rotation(rotation_radians)-> void:
	#grid_rotation = rotation_radians

func update_ball_position():
	ball_in_slot.position = get_current_position()

func set_ball_in_slot(new_ball : BaseBall):
	ball_in_slot = new_ball
	var ball_position_tween = ball_in_slot.create_tween()
	ball_position_tween.set_ease(Tween.EASE_OUT)
	ball_position_tween.tween_property(ball_in_slot, 'position', get_current_position(), .01)
	#ball_in_slot.position  = get_current_position()
	is_available = false

func get_adjacent_grid_positions() -> Array[Vector2i]:
	var adjacent_grid_positions_array : Array[Vector2i] = []
	for position_change in relative_positions_array:
		adjacent_grid_positions_array.append(grid_position + position_change)
	return adjacent_grid_positions_array

func get_types() -> Array[String]:
	if ball_in_slot:
		return types + ball_in_slot.get_types()
	else:
		return types
func has_ball() -> bool:
	if ball_in_slot != null:
		return true
	else:
		return false

func make_active():
	is_active = true

func make_inactive():
	is_active = false

func make_available():
	if !ball_in_slot:
		is_available = true
		is_active = true
		$Sprite2D.visible = true
		$Label.visible = true

func make_unavailable():
	is_available = false
	$Sprite2D.visible = false
	$Label.visible = false
	
