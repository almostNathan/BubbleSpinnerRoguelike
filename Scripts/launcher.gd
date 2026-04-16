extends Node2D
class_name Launcher

var bubble_queue : BubbleQueue = preload("res://Scenes/bubble_queue.tscn").instantiate()

var y_position = 24
var current_bubble : BaseBubble 
var bubbles_fired = 0
var shot_bubbles : Array[BaseBubble] = []

func _ready() -> void:
	self.position = Vector2(get_viewport_rect().size.x/2, y_position)
	pass

func new_round() -> void:
	bubble_queue.reload_current_queue()
	reload()

func reload() -> void:
	var new_bubble : BaseBubble = bubble_queue.get_next_bubble()
	new_bubble.position = self.position
	new_bubble.set_label(str(shot_bubbles))
	new_bubble.deactivate()
	self.add_sibling(new_bubble)
	current_bubble = new_bubble


func _physics_process(delta: float) -> void:
	rotation = global_position.angle_to_point(get_global_mouse_position()) - PI/2

func fire_launcher():
	if current_bubble != null:
		current_bubble.set_movement_direction(current_bubble.global_position.direction_to(get_global_mouse_position()))
		current_bubble.activate()
		SignalHub.emit_bubble_shot(current_bubble, self)
		#shot_bubbles.append(current_bubble)
		current_bubble = null
		bubbles_fired += 1

		await get_tree().create_timer(1).timeout
		
		reload()
	else:
		pass
		#play some animation if not reloaded yet
		
