extends CanvasLayer

@onready var score_label: Label = $VBoxContainer/HBoxContainer/ScoreLabel
@onready var last_score_label: Label = $VBoxContainer/HBoxContainer2/LastScoreLabel
@onready var spawn_countdown: Label = $SpawnCountdown

var score : int = 0
var last_score : int = 0

func change_score(change_value : int) -> void:
	self.last_score = change_value
	self.score += change_value
	refresh()

func set_spawn_countdown(new_value : int) -> void:
	spawn_countdown.text = str(new_value)

func refresh() -> void:
	score_label.text = str(score)
	last_score_label.text = str(last_score)
