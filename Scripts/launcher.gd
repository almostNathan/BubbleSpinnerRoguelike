extends Node2D
class_name Launcher

var ball_queue : BallQueue = preload("res://Scenes/ball_queue.tscn").instantiate()

var y_position = 24
var current_ball : BaseBall 
var balls_fired = 0
var shot_balls : Array[BaseBall] = []

func _ready() -> void:
	self.position = Vector2(get_viewport_rect().size.x/2, y_position)
	pass

func new_round() -> void:
	ball_queue.reload_current_queue()
	reload()

func reload() -> void:
	var new_ball : BaseBall = ball_queue.get_next_ball()
	new_ball.position = self.position
	new_ball.set_label(str(shot_balls))
	new_ball.deactivate()
	self.add_sibling(new_ball)
	current_ball = new_ball


func _physics_process(delta: float) -> void:
	rotation = global_position.angle_to_point(get_global_mouse_position()) - PI/2

func fire_launcher():
	if current_ball != null:
		current_ball.set_movement_direction(current_ball.global_position.direction_to(get_global_mouse_position()))
		current_ball.activate()
		#shot_balls.append(current_ball)
		current_ball = null
		balls_fired += 1

		await get_tree().create_timer(1).timeout
		
		reload()
	else:
		pass
		#play some animation if not reloaded yet
		
