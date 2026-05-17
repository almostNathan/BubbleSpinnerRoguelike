extends BubbleState
class_name BubbleLoadedState


func enter() -> void:
	bubble.collision_shape.disabled = true


func exit() -> void:
	bubble.collision_shape.disabled = false

func on_physics_process(_delta : float) -> void:
	bubble.rotation = bubble.global_position.angle_to_point(bubble.get_global_mouse_position()) - PI/2
	
func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		self.transition_requested.emit(self, BubbleState.State.SHOT)
