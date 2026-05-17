extends Node2D
class_name MainArena

@export var my_name : String

@onready var launcher : Launcher = $Launcher
@onready var bubble_grid_manager : BubbleGridManager = $BubbleGridManager
@onready var rotation_tracker : RotationTracker = $RotationTracker
@onready var background_color: ColorRect = $BackgroundColor

#func _physics_process(delta: float) -> void:
	#rotation_tracker.total_rotation = bubble_grid_manager.rotation
	
func _ready() -> void:
	#bubble_grid_manager.position = 
	bubble_grid_manager.set_up_grid_locations()
	launcher.new_round()

func change_background(new_color) -> void:
	self.background_color.color = new_color
	
