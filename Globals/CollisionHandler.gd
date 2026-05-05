extends Node


var collision_history : Dictionary = {}


func handle_collision(colliding_bubble : BaseBubble, collided_bubble : BaseBubble):
	#if we have captured the other collision event, resolve collision, else add collision event to history
	if collision_history.keys().has(collided_bubble):
		
		pass
	
	else:
		collision_history[colliding_bubble] = collided_bubble
