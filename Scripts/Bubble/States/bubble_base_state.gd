extends BubbleState
class_name BubbleBaseState
# Starting state for bubbles. used for bubbles in the queue off screen.

func exit() -> void:
	pass

func on_load(bubble : BaseBubble) -> void:
	transition_requested.emit(self, BubbleState.State.LOADED)
#
#func on_input(event: InputEvent) -> void:
	#if event.is_action_pressed("left_click"):
		#self.transition_requested.emit(self, BubbleState.State.SHOT)

func on_gui_input(_event: InputEvent) -> void:
	pass


func on_mouse_entered() -> void:
	pass


func on_mouse_exited() -> void:
	pass
