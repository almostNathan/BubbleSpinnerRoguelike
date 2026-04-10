extends Node2D
class_name BallQueue

var current_queue : Array[BaseBall] = []

func get_next_ball() -> BaseBall:
	if current_queue.is_empty():
		reload_current_queue()
	return current_queue.pop_front()


func reload_current_queue() -> void:
	for i in range(10):
		var new_ball = preload("res://Scenes/base_ball.tscn").instantiate()
		var new_type : String = BallTypes.types.keys().pick_random()
		new_ball.add_type(new_type, BallTypes.types[new_type]['color'])
		current_queue.append(new_ball)
	
	
