extends Node2D
class_name RotationTracker
#TODO - IDEAS
#
@onready var rotation_progress_bar = $RotationProgressBar
@onready var multiplier_label = $MultiplierLabel

const MAX_VALUE : float = 2 * PI
const LAYER_COLORS: Array[Color] = [
	Color("#2fa3ff"),  # sky blue
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
var total_rotation : float = 0
var current_layer : int  = -1

func _ready() -> void:
	self.position = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)
	SignalHub.connect_rotate_bubble_grid(change_value)
	SignalHub.connect_scoring_bubbles(on_scoring_bubbles)
	set_layers()
	
func _physics_process(delta: float) -> void:
	self.rotation_progress_bar.value = fmod(self.total_rotation, MAX_VALUE)
	set_layers()

func on_scoring_bubbles(score_number : ScoreNumber):
	score_number.score_value = score_number.score_value *  (current_layer+1)
	score_number.change_color(LAYER_COLORS[current_layer%9])
	

func change_value(bubble_grid : BubbleGridManager, rotation_change : float) -> void:
	self.total_rotation += abs(rotation_change)


func set_layers():
	var layer = floor(abs(total_rotation) / MAX_VALUE)
	if layer != current_layer:
		current_layer = layer
		var color_count = len(LAYER_COLORS) - 1
		rotation_progress_bar.tint_under = LAYER_COLORS[current_layer%color_count]
		rotation_progress_bar.tint_progress = LAYER_COLORS[(current_layer%color_count)+1]
		multiplier_label.text = "x"+ str(current_layer+1)


func get_tween() -> Tween:
	if value_tween:
		value_tween.kill()
	return get_tree().create_tween()


func _on_h_slider_value_changed(value: float) -> void:
	rotation_progress_bar.value = value
