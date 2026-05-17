extends BubbleState
class_name BubbleCollidedState
# Enter state when a collision is detected. 
# will determine whether to move to slotted state

func post_enter() -> void:
	var area := bubble.hitbox.get_overlapping_areas()[0]
	
	#bubble.on_collision.emit(bubble, area)
	if area.is_in_group('wall'):
		#TODO change to global signal and have all walls listen to the signal
		bubble.on_bounce.emit(bubble, area)
		area.bounce(bubble)
		self.transition_requested.emit(self, State.MOVING)
		
	if area.is_in_group('bubble') and !bubble.collided: 
		#TODO: check with collided bubble to determine outcome of collision
		if CollisionHandler.handle_collision(bubble, area.get_parent()):
			return
		else:
			self.transition_requested.emit(self, State.MOVING)
	
	if area.is_in_group("backstop"):
		bubble.queue_free()
