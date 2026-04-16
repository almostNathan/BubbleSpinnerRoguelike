extends Area2D
class_name LeftWall

func bounce(bubble : BaseBubble):
	bubble.change_movement_direction(Vector2(-1,1))
