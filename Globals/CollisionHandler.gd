extends Node




func handle_collision(colliding_bubble : BaseBubble, collided_bubble : BaseBubble):
	#if we have captured the other collision event, resolve collision, else add collision event to history
	
	collided_bubble.trigger_effects()
	
	#If slotting
	var bubble_grid_manager = get_tree().get_first_node_in_group("bubble_grid_manager")
	bubble_grid_manager.bubble_collided.call_deferred(colliding_bubble, collided_bubble)
	#SignalHub.emit_bubble_colliding.call_deferred(bubble, area.get_parent())
	#self.transition_requested.emit(self, State.SLOTTED) 
