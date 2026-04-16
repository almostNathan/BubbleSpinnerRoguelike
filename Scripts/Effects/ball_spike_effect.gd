extends BaseEffect
class_name SpikeBallEffect

var grid_slot : BallGridSlot
var target_relative_position : Vector2i
@onready var sprite : Sprite2D = $Sprite
var sprite_pos : Vector2 = Vector2(0,0)

func _ready():
	self.sprite.position = sprite_pos

func apply_effect(new_grid_slot : BallGridSlot) -> void:
	if new_grid_slot.has_ball() and randf() > .5:
		self.grid_slot = new_grid_slot
		print("spike_ball_effect applied")
		self.reparent(grid_slot.get_parent())
		##tween to new position
		var position_tween = get_tree().create_tween()
		position_tween.tween_property(sprite, 'position:x', 50, .2)
		position_tween.finished.connect(end_effect)
	else:
		queue_free()
	
func end_effect():
	self.grid_slot.destroy_slot()
	queue_free()
