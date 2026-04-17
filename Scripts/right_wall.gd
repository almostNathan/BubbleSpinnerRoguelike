extends Area2D
class_name RightWall

func _ready() -> void:
	self.position = Vector2(get_viewport_rect().size.x,get_viewport_rect().size.y/2)

func bounce(bubble : BaseBubble):
	bubble.add_mod(preload("res://Scenes/Mods/BubbleMods/spike_bubble_mod.tscn").instantiate())
	bubble.change_movement_direction(Vector2(-1,1))
