extends BaseBubbleMod
class_name BouncyBubbleMod


func attach(new_bubble : BaseBubble) -> void:
	super(new_bubble)
	new_bubble.add_child(self)
	#if new_bubble.collision_handler:
		#new_bubble.collision_handler
	#new_bubble.replace_collision_handler(BouncyCollisionHandler.new())
	#new_bubble.ball_collision = func(area):
		##SignalHub.emit_bubble_colliding.call_deferred(self, area.get_parent())
		#new_bubble.movement_direction = Vector2(0,-1)
		

#func _on_collision(shot_bubble : BaseBubble, collided_bubble : BaseBubble):
	#if collided_bubble == self.bubble:
		#print("on_collision bouncybubblemod")
		#shot_bubble.collided = false
		#shot_bubble.set_movement_direction(collided_bubble.position - shot_bubble.position) 
