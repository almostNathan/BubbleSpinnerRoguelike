extends BubbleState
class_name BubbleMovingState

func enter() -> void:
	bubble.activate()
	bubble.enable()
	
func on_physics_process(delta : float):
	bubble.position += bubble.movement_direction * bubble.cur_speed * delta

func on_collision(area : Area2D):
	self.transition_requested.emit(self, State.COLLIDED)
	
