extends Node

signal bubble_colliding(shot_bubble : BaseBubble, collided_bubble : BaseBubble)
signal bubble_shot(shot_bubble : BaseBubble, launcher : Launcher)
signal bubble_destroyed(destroyed_bubble : BaseBubble)
signal apply_effect_to_bubble_slot(effect : BaseEffect, bubble_slot_coords : Vector2i)

## Bubble Destroyed
func connect_bubble_destroyed(callable : Callable):
	self.bubble_destroyed.connect(callable)
func emit_bubble_destroyed(_destroyed_bubble):
	bubble_destroyed.emit(_destroyed_bubble)

## Bubble Colliding
func connect_bubble_colliding(callable : Callable):
	self.bubble_colliding.connect(callable)
func emit_bubble_colliding(_shot_bubble, _collided_bubble):
	bubble_colliding.emit(_shot_bubble, _collided_bubble)

## Bubble Shot
func connect_bubble_shot(callable : Callable):
	self.bubble_shot.connect(callable)
func emit_bubble_shot(_shot_bubble, _launcher):
	bubble_shot.emit(_shot_bubble, _launcher)

# Apply Effect to Bubble Slot
func connect_apply_effect_to_bubble_slot(callable : Callable):
	self.apply_effect_to_bubble_slot.connect(callable)
func emit_apply_effect_to_bubble_slot(_effect_callable, _bubble_slot_coords):
	apply_effect_to_bubble_slot.emit(_effect_callable, _bubble_slot_coords)
