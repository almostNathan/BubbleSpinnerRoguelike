extends BubbleState
class_name BouncySlottedState

var allowed_bounces = 100
var bounce_count = 0

func attach(new_bubble : BaseBubble) -> void:
	if new_bubble.is_inside_tree():
		new_bubble.bubble_state_machine.replace_state(BubbleState.State.SLOTTED, self)
	else:
		new_bubble.ready.connect(attach)
	var sprite = Sprite2D.new()
	sprite.texture = load("res://Assets/Textures/bounce.png")
	sprite.scale = Vector2(.05, .05)
	new_bubble.add_child(sprite)
	


func collision_override(shot_bubble : BaseBubble):
	if bounce_count < allowed_bounces:
		print("bouncyslottedstaate collisionoverride")
		var bubble_grid_manager = get_tree().get_first_node_in_group("bubble_grid_manager")
		bubble_grid_manager.rotate_bubble_grid(shot_bubble, bubble)
		var collision_normal = (shot_bubble.global_position - self.bubble.global_position).normalized()
		shot_bubble.movement_direction = shot_bubble.movement_direction.bounce(collision_normal)
		#bounce_count += 1
		if bounce_count >= allowed_bounces:
			self.queue_free()
		return true
