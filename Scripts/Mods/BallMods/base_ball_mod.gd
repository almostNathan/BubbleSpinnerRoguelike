extends Node2D
class_name BaseBallMod

var ball : BaseBall 

func attach(new_ball : BaseBall) -> void:
	ball = new_ball

func clean_up():
	if ball == null:
		self.queue_free()
