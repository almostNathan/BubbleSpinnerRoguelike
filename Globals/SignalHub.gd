extends Node

signal ball_colliding(shot_ball : BaseBall, collided_ball : BaseBall)
signal ball_shot(shot_ball : BaseBall, launcher : Launcher)
signal apply_effect_to_ball_slot(effect : BaseEffect, ball_slot_coords : Vector2i)

func connect_ball_colliding(callable : Callable):
	self.ball_colliding.connect(callable)
func emit_ball_colliding(_shot_ball, _collided_ball):
	ball_colliding.emit(_shot_ball, _collided_ball)


func connect_ball_shot(callable : Callable):
	self.ball_shot.connect(callable)
func emit_ball_shot(_shot_ball, _launcher):
	ball_shot.emit(_shot_ball, _launcher)

func connect_apply_effect_to_ball_slot(callable : Callable):
	self.ball_shot.connect(callable)
func emit_apply_effect_to_ball_slot(_effect_callable, _ball_slot_coords):
	ball_shot.emit(_effect_callable, _ball_slot_coords)
