extends Node2D
class_name BallQueue

var current_queue : Array[BaseBall] = []

func get_next_ball() -> BaseBall:
	if current_queue.is_empty():
		print("launcher reloading")
		reload_current_queue()
	return current_queue.pop_front()
	
func reload_current_queue() -> void:
	for i in range(6):
		var new_ball = preload("res://Scenes/base_ball.tscn").instantiate()
		current_queue.append(new_ball)
	current_queue[0].add_type("red", Color(1.0, 0.0, 0.0,1))
	current_queue[1].add_type("red", Color(1.0, 0.0, 0.0,1))
	current_queue[2].add_type("green", Color(0.0, 1.0, 0.0,1))
	current_queue[3].add_type("green", Color(0.0, 1.0, 0.0,1))
	current_queue[4].add_type("blue", Color(0.0, 0.0, 1.0,1))
	current_queue[5].add_type("blue", Color(0.0, 0.0, 1.0,1))
	
	print(current_queue)
	
