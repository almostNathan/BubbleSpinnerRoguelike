extends CollisionHandler
class_name BouncyCollisionHandler


static func get_new_instance() -> BouncyCollisionHandler:
	var new_instance := new()
	return new_instance


func handle_collision(bubble : BaseBubble, area : Area2D):
	print("bouncy collision handler")
	if area.is_in_group('wall'):
		#TODO change to global signal and have all walls listen to the signal
		bubble.on_bounce.emit(bubble, area)
		area.bounce(bubble)
	if area.is_in_group('bubble') and bubble.collided:
		var shot_bubble = area.parent()
		if area.parent() == self.bubble:
			print("on_collision bouncybubblemod")
			shot_bubble.collided = false
			shot_bubble.active = true
			shot_bubble.set_movement_direction(bubble.position - shot_bubble.position)  
			SignalHub.emit_bubble_colliding(bubble,area.get_parent())
			
