extends Node2D
class_name BaseBubble

signal on_destroy(bubble)
signal on_remove(bubble)
signal on_bounce(bubble, area)

const BUBBLE_RADIUS = 20

@onready var sprite = $Sprite2D
@onready var hitbox = $Area2D

@export var color = Color(0,.6,.6,1)

var speed : float = 1500
var movement_direction : Vector2 = Vector2(0,0)
var active = true
var collided = false

var types : Array[String] = []
var slot : BubbleGridSlot

func _ready():
	sprite.modulate = color

#func set_label(bubble_pos: Vector2i):
	#$Label.text = str(int(bubble_pos.x)) + "," + str(int(bubble_pos.y))
func set_label(bubble_num : String) -> void:
	$Label.text = bubble_num

func _physics_process(delta: float) -> void:
	if active:
		self.position += movement_direction * speed * delta

func aim_at(target_position : Vector2):
	self.movement_direction = self.global_position.direction_to(target_position)

func set_movement_direction(new_movement_direction : Vector2):
	self.movement_direction = new_movement_direction.normalized()

func add_type(new_type : String, new_color : Color) -> void:
	types.append(new_type)
	self.color = new_color

func set_slot(new_slot : BubbleGridSlot) -> void:
	self.slot = new_slot

func get_grid_position() -> Vector2i:
	return slot.grid_position

func get_types() -> Array[String]:
	return types

func destroy() -> void:
	await get_tree().create_timer(.2).timeout
	self.on_destroy.emit(self)
	self.on_remove.emit(self)
	self.queue_free()

func put_bubble_in_position(new_position : Vector2):
	self.position = new_position
	self.speed = 0

func score_bubble() -> int:
	if len(types) != 0:
		var score_sum = 0
		for type in types:
			score_sum += BubbleTypes.types[type]['value']
		return score_sum
	else:
		return 0

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.has_method('bounce'):
		on_bounce.emit(self, area)
		area.bounce(self)
	if area.is_in_group('bubble'):
		if !collided:
			SignalHub.emit_bubble_colliding(self,area.get_parent())
			self.speed = 0
			collided = true

func change_movement_direction(change_vector : Vector2):
	self.movement_direction *= change_vector

func add_mod(new_mod:BaseBubbleMod):
	new_mod.attach(self)
	

func deactivate():
	active = false

func activate():
	active = true
