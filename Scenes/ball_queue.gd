extends Node2D
class_name BallQueue

var current_queue : Array[BaseBall] = []

func get_next_ball() -> BaseBall:
	if current_queue.is_empty():
		reload_current_queue()
	return current_queue.pop_front()
	
	


func reload_current_queue() -> void:
	var types = [
			["red", Color(1.0, 0.0, 0.0,1)],
			["green", Color(0.0, 1.0, 0.0,1)],
			["blue", Color(0.0, 0.0, 1.0,1)],
			["yellow", Color(1.0, 1.0, 0.0,1)],
			["cyan", Color(0.0, 1.0, 1.0,1)],
			["purple", Color(1.0, 0.0, 1.0,1)],
		]
	for i in range(10):
		var new_ball = preload("res://Scenes/base_ball.tscn").instantiate()
		var selected_type = types.pick_random()
		new_ball.add_type(selected_type[0], selected_type[1])
		current_queue.append(new_ball)
	
	
