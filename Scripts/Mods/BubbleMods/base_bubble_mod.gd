extends Node2D
class_name BaseBubbleMod

var bubble : BaseBubble 

func attach(new_bubble : BaseBubble) -> void:
	self.bubble = new_bubble

func clean_up():
	if bubble == null:
		self.queue_free()
