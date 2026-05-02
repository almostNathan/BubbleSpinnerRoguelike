extends Node
class_name BubbleStateMachine

@export var initial_state: BubbleState

var current_state: BubbleState
var states := {}


func init(new_bubble: BaseBubble) -> void:
	SignalHub.loading_bubble.connect(on_load)
	SignalHub.loading_bubble.connect(on_load)
	for child: BubbleState in get_children():
		if child:
			states[child.state] = child
			child.transition_requested.connect(_on_transition_requested)
			child.bubble = new_bubble
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func on_physics_process(delta : float):
	if current_state:
		current_state.on_physics_process(delta)

func on_collision(area):
	if current_state:
		current_state.on_collision(area)

func on_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_input(event)

func on_set_slot(new_slot : BubbleGridSlot):
	if current_state:
		current_state.on_set_slot(new_slot)

func on_gui_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_gui_input(event)


func on_mouse_entered() -> void:
	if current_state:
		current_state.on_mouse_entered()


func on_mouse_exited() -> void:
	if current_state:
		current_state.on_mouse_exited()

func on_load(bubble : BaseBubble) -> void:
	if current_state:
		current_state.on_load(bubble)

func _on_transition_requested(from: BubbleState, to: BubbleState.State) -> void:
	if from != current_state:
		return
		
	var new_state: BubbleState = states[to]
	if not new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state
	new_state.post_enter()

func force_state(to : BubbleState.State):
	var new_state: BubbleState = states[to]
	if not new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state
	new_state.post_enter()
