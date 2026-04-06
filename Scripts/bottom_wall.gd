extends Area2D
class_name BottomWall

func _ready() -> void:
	self.position = Vector2(get_viewport_rect().size.x/2,get_viewport_rect().size.y)
	
func bounce(ball : BaseBall):
	ball.change_movement_direction(Vector2(1,-1))
