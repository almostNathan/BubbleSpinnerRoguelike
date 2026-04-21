extends Node2D
class_name RotationTracker

@onready var rotation_tracker = $TextureProgressBar

const MAX_VALUE = 2 * PI
const LAYER_COLORS: Array[Color] = [
	Color("#4fc3f7"),  # sky blue
	Color("#81c784"),  # soft green
	Color("#ffb74d"),  # warm amber
	Color("#f06292"),  # rose pink
	Color("#ce93d8"),  # lavender
	Color("#4dd0e1"),  # cyan
	Color("#aed581"),  # lime
	Color("#ff8a65"),  # coral
	Color("#90caf9"),  # light blue
	Color("#fff176"),  # pale yellow
]

var value_tween : Tween
var total_value : float = 0
var shown_value : float = 0
var current_layer = 0

func _ready() -> void:
	rotation_tracker.max_value = 2 * PI 
	self.position = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)
	SignalHub.connect_rotate_bubble_grid(change_value)
	set_layers()
	
func _physics_process(delta: float) -> void:
	var layer = floor(total_value / MAX_VALUE)
	if layer != current_layer:
		current_layer = layer
		set_layers()
	if rotation_tracker.value > MAX_VALUE:
		rotation_tracker.value = 0

func change_value(bubble_grid : BubbleGridManager, rotation_change : float, new_rotation_value : float) -> void:
	total_value = new_rotation_value
	#shown_value = fmod(total_value, MAX_VALUE)
	value_tween = get_tween()
	value_tween.set_trans(Tween.TRANS_QUART)
	value_tween.set_ease(Tween.EASE_OUT)
	value_tween.tween_property(rotation_tracker, 'value', total_value, 1)
	#value_tween.finished.connect(value_tween.kill)

func set_layers():
	#TODO based on the current value, determine what layers we should be using and truncate the value
	rotation_tracker.tint_under = LAYER_COLORS[current_layer]
	rotation_tracker.tint_progress = LAYER_COLORS[current_layer+1]
	pass


func get_tween() -> Tween:
	if value_tween:
		value_tween.kill()
	return get_tree().create_tween()
