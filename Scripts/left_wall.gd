extends Area2D
class_name LeftWall

@onready var color_rect: ColorRect = $ColorRect
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	var viewport_height : float = get_viewport_rect().size.y
	var viewport_width : float = get_viewport_rect().size.x
	self.position = Vector2((viewport_width/2) - (viewport_height/2) ,get_viewport_rect().size.y/2)
	self.color_rect.size = collision_shape_2d.shape.size
	self.color_rect.position = Vector2(-collision_shape_2d.shape.size.x/2,-collision_shape_2d.shape.size.y/2)
	
func bounce(bubble : BaseBubble):
	bubble.change_movement_direction(Vector2(-1,1))
