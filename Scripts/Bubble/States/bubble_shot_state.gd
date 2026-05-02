extends BubbleState
class_name BubbleShotState



func enter() -> void:
	print(self, " entering shot state")
	bubble.on_shoot.emit(bubble)
	
	bubble.set_movement_direction(bubble.global_position.direction_to(bubble.get_global_mouse_position()))

func post_enter() -> void:
	self.transition_requested.emit(self, BubbleState.State.MOVING)
