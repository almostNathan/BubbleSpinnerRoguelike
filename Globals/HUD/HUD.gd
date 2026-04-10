extends CanvasLayer

@onready var score_label = $VBoxContainer/ScoreLabel
@onready var last_score_label = $VBoxContainer/LastScoreLabel

var score : int = 0
var last_score : int = 0

func change_score(change_value : int) -> void:
	self.last_score = change_value
	self.score += change_value
	refresh()
	

func refresh() -> void:
	score_label.text = str(score)
	last_score_label.text = str(last_score)
