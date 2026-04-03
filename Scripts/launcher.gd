extends Node2D
class_name Launcher

var ball_queue : Array[BaseBall] = []

var current_ball : BaseBall 
var balls_fired = 0
var shot_balls : Array[BaseBall] = []

func _ready() -> void:
	reload_ball_queue()
	load_next_ball()


func load_ball(new_ball : BaseBall) -> void:
	print("\nlauncher, loading next ball #", balls_fired)
	current_ball = new_ball
	current_ball.set_label(str(balls_fired))
	balls_fired += 1
	current_ball.position = self.position
	
	current_ball.deactivate()
	self.add_sibling(current_ball)

	

func reload_ball_queue() -> void:
	for i in range(5):
		var new_ball = preload("res://Scenes/base_ball.tscn").instantiate()
		new_ball.color = Color(i/5.0, i/5.0, i/5.0, 1)
		ball_queue.append(new_ball)


func _physics_process(delta: float) -> void:
	rotation = global_position.angle_to_point(get_global_mouse_position()) - PI/2

func load_next_ball():
	if ball_queue.is_empty():
		print("launcher reloading")
		reload_ball_queue()
	load_ball(ball_queue.pop_front())

func fire_launcher():
	print("launcher balls in queue: ", len(ball_queue))
	current_ball.set_movement_direction(current_ball.global_position.direction_to(get_global_mouse_position()))
	current_ball.activate()
	#shot_balls.append(current_ball)

	#for i in range(len(shot_balls)):
		#print("launcher ball position #", i, " ", shot_balls[i].position)
	load_next_ball()
