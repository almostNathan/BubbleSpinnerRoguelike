extends Node2D
class_name MainArena

@onready var launcher = $Launcher
@onready var ball_grid_manager = $BallGridManager
@onready var start_point = $StartPoint

func _ready() -> void:
	#ball_grid_manager.position = 
	ball_grid_manager.set_up_grid_locations()
	#ball_grid_manager.rotate_grid(1.0)
	#for new_position in grid_positions.keys():
		#var new_ball = preload("res://Scenes/base_ball.tscn").instantiate()
		#new_ball.position = grid_positions[new_position]
		#new_ball.speed = 0
		#new_ball.set_label(new_position)
		#self.add_child(new_ball)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('left_click'):
		var new_ball = preload("res://Scenes/base_ball.tscn").instantiate()
		new_ball.position = launcher.position
		new_ball.set_movement_direction(launcher.global_position.direction_to(get_global_mouse_position()))
		self.add_child(new_ball)


func _physics_process(delta: float) -> void:
	launcher.rotation = launcher.global_position.angle_to_point(get_global_mouse_position()) - PI/2
