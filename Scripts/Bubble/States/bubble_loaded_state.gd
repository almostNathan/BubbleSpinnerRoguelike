extends BubbleState
class_name BubbleLoadedState



func enter() -> void:
	print(self, " entering loaded state")


func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		self.transition_requested.emit(self, BubbleState.State.SHOT)
