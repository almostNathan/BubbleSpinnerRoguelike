extends BubbleState
class_name BubbleShotState

func enter() -> void:
	bubble.on_shoot.emit(bubble)
	SignalHub.emit_bubble_shot(bubble)
	bubble.set_movement_direction(bubble.global_position.direction_to(bubble.get_global_mouse_position()))

func post_enter() -> void:
	print("post enter shot state")
	self.transition_requested.emit(self, BubbleState.State.MOVING)
