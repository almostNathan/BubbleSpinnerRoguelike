extends Node2D
class_name Launcher

#var bubble_queue : BubbleQueue = preload("res://Scenes/bubble_queue.tscn").instantiate()
@onready var bubble_queue: BubbleQueue = $BubbleQueue

var y_position = 24
var current_bubble : BaseBubble 
var bubbles_fired = 0
var shot_bubbles : Array[BaseBubble] = []

func _ready() -> void:
	self.position = Vector2(get_viewport_rect().size.x/2, y_position)
	SignalHub.connect_bubble_shot(bubble_shot)

func new_round() -> void:
	bubble_queue.reload_current_queue()
	reload()

func bubble_shot(_shot_bubble : BaseBubble) -> void:
	reload()


func reload() -> void:
	await get_tree().create_timer(.5).timeout
	var new_bubble : BaseBubble = bubble_queue.get_next_bubble()
	new_bubble.position = self.position
	new_bubble.set_label(str(shot_bubbles))
	new_bubble.deactivate()
	new_bubble.disable()
	self.add_sibling(new_bubble)
	current_bubble = new_bubble
	SignalHub.loading_bubble.emit(current_bubble)


func _physics_process(_delta: float) -> void:
	rotation = global_position.angle_to_point(get_global_mouse_position()) - PI/2
	queue_redraw()

func _draw() -> void:
	draw_line(Vector2(0,0), get_local_mouse_position(),Color.BLACK)



#func fire_launcher():
	#if current_bubble != null:
		##SignalHub.emit_bubble_shot(current_bubble, self)
		##shot_bubbles.append(current_bubble)
		#current_bubble = null
		#bubbles_fired += 1
		#await get_tree().create_timer(1).timeout
		#reload()
	#else:
		#pass
