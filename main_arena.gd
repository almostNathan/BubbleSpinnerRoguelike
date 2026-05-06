extends Node2D
class_name MainArena

@export var my_name : String

@onready var launcher : Launcher = $Launcher
@onready var bubble_grid_manager : BubbleGridManager = $BubbleGridManager
@onready var rotation_tracker : RotationTracker = $RotationTracker
#@onready var start_point : StartPoint = $StartPoint

#func _physics_process(delta: float) -> void:
	#rotation_tracker.total_rotation = bubble_grid_manager.rotation
	
func _ready() -> void:
	#bubble_grid_manager.position = 
	bubble_grid_manager.set_up_grid_locations()
	launcher.new_round()

	#bubble_grid_manager.rotate_grid(1.0)
	#for new_position in grid_positions.keys():
		#var new_bubble = preload("res://Scenes/base_bubble.tscn").instantiate()
		#new_bubble.position = grid_positions[new_position]
		#new_bubble.speed = 0
		#new_bubble.set_label(new_position)
		#self.add_child(new_bubble)

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed('left_click'):
		#launcher.fire_launcher()
