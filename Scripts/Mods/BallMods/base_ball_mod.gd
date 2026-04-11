extends Node2D
class_name BaseBallMod

var ball : BaseBall 

func attach(new_ball : BaseBall) -> void:
	ball = new_ball
	ball.on_destroy.connect(trigger_spikes)

func trigger_spikes() -> void:
	pass
