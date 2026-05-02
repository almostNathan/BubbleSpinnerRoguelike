extends BubbleState
class_name BubbleMovingState



func enter() -> void:
	print(self, " entering moving state")
	bubble.activate()
	bubble.enable()
	
func on_physics_process(delta : float):
	bubble.position += bubble.movement_direction * bubble.cur_speed * delta

func on_collision(bubble : BaseBubble, area : Area2D):
	if area.is_in_group('wall'):
		#TODO change to global signal and have all walls listen to the signal
		bubble.on_bounce.emit(bubble, area)
		area.bounce(bubble)
	if area.is_in_group('bubble') and !bubble.collided: 
		bubble.cur_speed = 0
		bubble.collided = true
		transition_requested.emit(self, BubbleState.State.COLLIDED)
		SignalHub.emit_bubble_colliding(bubble, area.get_parent())
		
