extends Node2D
class_name MainArena

@onready var launcher = $Launcher
@onready var ball_grid_manager = $BallGridManager
@onready var start_point = $StartPoint

func _ready() -> void:
	#ball_grid_manager.position = 
	ball_grid_manager.set_up_grid_locations()
	launcher.new_round()
	#ball_grid_manager.rotate_grid(1.0)
	#for new_position in grid_positions.keys():
		#var new_ball = preload("res://Scenes/base_ball.tscn").instantiate()
		#new_ball.position = grid_positions[new_position]
		#new_ball.speed = 0
		#new_ball.set_label(new_position)
		#self.add_child(new_ball)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('left_click'):
		launcher.fire_launcher()
