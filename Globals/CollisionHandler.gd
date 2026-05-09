extends Node




func handle_collision(incoming_bubble : BaseBubble, collided_bubble : BaseBubble) -> bool:
	#if we have captured the other collision event, resolve collision, else add collision event to history
	#collided_bubble.trigger_effects()
	if collided_bubble.collision_override(incoming_bubble):
		return false
	else:
		#If slotting
		var bubble_grid_manager = get_tree().get_first_node_in_group("bubble_grid_manager")
		bubble_grid_manager.bubble_collided.call_deferred(incoming_bubble, collided_bubble)
		return true
