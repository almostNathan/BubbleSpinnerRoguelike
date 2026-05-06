extends Node2D
class_name BaseBubble

signal on_destroy(bubble)
signal on_remove(bubble)
signal on_bounce(bubble, area)
signal on_collision(bubble, area)
signal on_shoot(bubble)

const BUBBLE_RADIUS = 20

@onready var sprite : Sprite2D = $Sprite2D
@onready var hitbox : Area2D = $Area2D
#@onready var collision_handler = CollisionHandler.new()
@onready var bubble_state_machine: BubbleStateMachine = $BubbleStateMachine

@export var color = Color(0,.6,.6,1)


var speed : float = Util.base_values['base_bubble_speed']
var cur_speed : float = speed
var weight : float = Util.base_values['base_bubble_weight']
var movement_direction : Vector2 = Vector2(0,0)
var active = true
var bouncy = false
var collided = false

var types : Array[String] = []
var slot : BubbleGridSlot

func _ready():
	sprite.modulate = color
	if bubble_state_machine:
		bubble_state_machine.init(self)
	#self.cur_speed = 3000
	#self.speed = 3000
	#self.weight = 10

func set_label(bubble_num : String) -> void:
	$Label.text = bubble_num

func _physics_process(delta: float) -> void:
	if bubble_state_machine:
		bubble_state_machine.on_physics_process(delta)

func _input(event: InputEvent) -> void:
	if bubble_state_machine:
		bubble_state_machine.on_input(event)

func aim_at(target_position : Vector2):
	self.movement_direction = self.global_position.direction_to(target_position)

func set_movement_direction(new_movement_direction : Vector2):
	self.movement_direction = new_movement_direction.normalized()

func add_type(new_type : String, new_color : Color) -> void:
	types.append(new_type)
	self.color = new_color

func set_slot(new_slot : BubbleGridSlot) -> void:
	if bubble_state_machine:
		return bubble_state_machine.set_slot(new_slot)
	self.slot = new_slot

func get_grid_position() -> Vector2i:
	return slot.grid_position

func get_types() -> Array[String]:
	return types

func clear() -> void:
	await get_tree().create_timer(.2).timeout
	self.on_remove.emit(self)
	self.queue_free()

func destroy() -> void:
	await get_tree().create_timer(.2).timeout
	SignalHub.emit_bubble_destroyed(self)
	self.on_destroy.emit(self)
	self.on_remove.emit(self)
	self.queue_free()



func score_bubble() -> int:
	if len(types) != 0:
		var score_sum = 0
		for type in types:
			score_sum += BubbleTypes.types[type]['value']
		return score_sum
	else:
		return 0

func _on_area_2d_area_entered(area: Area2D) -> void:
	#self.collided = true
	if self.bubble_state_machine:
		self.bubble_state_machine.on_collision(area)
	#self.on_collision.emit(self, area)
	#self.collision_handler.handle_collision(self, area)

##Function for when this object is collided into. 
func collided_into(bubble : BaseBubble) -> void:
	if self.bubble_state_machine:
		self.bubble_state_machine.on_collided_into(bubble)

func change_movement_direction(change_vector : Vector2):
	self.movement_direction *= change_vector

func add_mod(new_mod:BaseBubbleMod):
	new_mod.attach(self)

func deactivate():
	active = false

func activate():
	active = true

func disable():
	$Area2D/CollisionShape2D.disabled = true
func enable():
	$Area2D/CollisionShape2D.disabled = false
