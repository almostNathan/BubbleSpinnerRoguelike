extends BubbleState
class_name BubbleCollidedState
# Enter state when a collision is detected. 
# will determine whether to move to slotted state

func enter() -> void:
	print(self, " entering collided state")
