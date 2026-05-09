extends BaseBubbleMod
class_name BouncySlottedMod


func attach(new_bubble : BaseBubble) -> void:
	super(new_bubble)
	new_bubble.add_child(self)
	new_bubble.on_collision_override.connect(_collision_override)
	#if new_bubble.collision_handler:
		#new_bubble.collision_handler
	#new_bubble.replace_collision_handler(BouncyCollisionHandler.new())
	#new_bubble.ball_collision = func(area):
		##SignalHub.emit_bubble_colliding.call_deferred(self, area.get_parent())
		#new_bubble.movement_direction = Vector2(0,-1)
		

func _collision_override(shot_bubble : BaseBubble, bubble_state : BubbleState.State):
	if bubble_state == BubbleState.State.SLOTTED:
		var collision_normal = (shot_bubble.position - self.bubble.position).normalized()
		shot_bubble.movement_direction = shot_bubble.movement_direction.reflect(collision_normal)
