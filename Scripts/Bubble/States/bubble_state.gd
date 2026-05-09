extends Node
class_name BubbleState

enum State {BASE, LOADED, SHOT, MOVING, COLLIDED, SLOTTED}

signal transition_requested(from: BubbleState, to: State)

@export var state: State

var bubble: BaseBubble


func enter() -> void:
	pass

func post_enter() -> void:
	pass

func exit() -> void:
	pass

func set_slot(new_slot : BubbleGridSlot):
	self.transition_requested.emit(self, State.SLOTTED)

func on_collision(_area : Area2D) -> void:
	pass

func on_score(score_number : ScoreNumber) -> void:
	if len(bubble.types) != 0:
		var score_sum = 0
		for type in bubble.types:
			score_sum += BubbleTypes.types[type]['value']
		score_number.score_value += score_sum

func collision_override(incoming_bubble : BaseBubble) -> bool:
	return false

func on_collided_into(bubble : BaseBubble) -> void:
	pass

func on_physics_process(_delta : float) -> void:
	pass

func on_load(bubble : BaseBubble) -> void:
	pass

func on_input(_event: InputEvent) -> void:
	pass

func on_set_slot(new_slot : BubbleGridSlot):
	pass

func on_gui_input(_event: InputEvent) -> void:
	pass

func on_mouse_entered() -> void:
	pass


func on_mouse_exited() -> void:
	pass
