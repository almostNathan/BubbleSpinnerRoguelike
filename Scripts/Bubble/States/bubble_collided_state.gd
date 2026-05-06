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
		CollisionHandler.handle_collision(bubble, area.get_parent())
		#bubble.cur_speed = 0
		bubble.collided = true
		var bubble_grid_manager = get_tree().get_first_node_in_group("bubble_grid_manager")
		bubble_grid_manager.bubble_collided.call_deferred(bubble, area.get_parent())
		#SignalHub.emit_bubble_colliding.call_deferred(bubble, area.get_parent())
		self.transition_requested.emit(self, State.SLOTTED)
		
