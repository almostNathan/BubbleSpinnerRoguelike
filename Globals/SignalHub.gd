extends Node

signal ball_colliding(shot_ball, collided_ball)


func connect_ball_colliding(callable : Callable):
	self.ball_colliding.connect(callable)
func emit_ball_colliding(_shot_ball, _collided_ball):
	ball_colliding.emit(_shot_ball, _collided_ball)
