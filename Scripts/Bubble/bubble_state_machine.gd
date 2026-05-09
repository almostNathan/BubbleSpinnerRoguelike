extends Node
class_name BubbleStateMachine

@export var initial_state: BubbleState

var bubble : BaseBubble
var current_state : BubbleState
var states := {}


func init(new_bubble: BaseBubble) -> void:
	self.bubble = new_bubble
	SignalHub.loading_bubble.connect(on_load)
	for child: BubbleState in get_children():
		if child:
			states[child.state] = child
			child.transition_requested.connect(_on_transition_requested)
			child.bubble = new_bubble
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state


func set_slot(new_slot : BubbleGridSlot):
	if current_state:
		current_state.set_slot(new_slot)

func on_physics_process(delta : float):
	if current_state:
		current_state.on_physics_process(delta)

func on_collision(area : Area2D):
	if current_state:
		current_state.on_collision(area)

func collision_override(incoming_bubble : BaseBubble) -> bool:
	if current_state:
		return current_state.collision_override(incoming_bubble)
	else:
		return false
		
func on_collided_into(bubble : BaseBubble):
	if current_state:
		current_state.on_collided_into(bubble)
		
func on_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_input(event)

func on_set_slot(new_slot : BubbleGridSlot):
	if current_state:
		current_state.on_set_slot(new_slot)

func on_gui_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_gui_input(event)

func on_score(score_number : ScoreNumber) -> void:
	if current_state:
		current_state.on_score(score_number)

func on_mouse_entered() -> void:
	if current_state:
		current_state.on_mouse_entered()


func on_mouse_exited() -> void:
	if current_state:
		current_state.on_mouse_exited()

func on_load(bubble : BaseBubble) -> void:
	if current_state:
		current_state.on_load(bubble)

func replace_state(state_key: BubbleState.State, new_state: BubbleState) -> void:
	print("replacing State")
# If this state is currently active, exit it first
	var is_active = current_state == states.get(state_key)
	if is_active:
		current_state.exit()

# Clean up the old state node
	var old_state = states.get(state_key)
	if old_state:
		old_state.transition_requested.disconnect(_on_transition_requested)
		old_state.queue_free()

# Set up and register the new state node
	new_state.bubble = bubble
	new_state.transition_requested.connect(_on_transition_requested)
	add_child(new_state)
	states[state_key] = new_state

# If we replaced the active state, enter the new one immediately
	if is_active:
		new_state.enter()
		current_state = new_state
		current_state.post_enter()


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
