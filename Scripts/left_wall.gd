extends Area2D
class_name LeftWall

func bounce(ball : BaseBall):
	ball.change_movement_direction(Vector2(-1,1))
