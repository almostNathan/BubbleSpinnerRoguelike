extends Node2D
class_name RoundHandler

var score_targets : Array[int] = [150, 500, 2000]
var current_round : int = 0
var round_colors : Array[Color] = [
	Color('547ae2'),
	Color('489274'),
	Color('af7040'),
]
var main_arena

func _ready() -> void:
	SignalHub.connect_changing_score(score_changed)
	main_arena = self.get_parent()
	
func score_changed(old_score : int, new_score : int) -> void:
	if new_score > score_targets[current_round]:
		current_round += 1
		main_arena.change_background(round_colors[current_round])
