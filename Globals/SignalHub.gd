extends Node

signal loading_bubble(bubble : BaseBubble)
signal bubble_colliding(shot_bubble : BaseBubble, collided_bubble : BaseBubble)
signal bubble_shot(shot_bubble : BaseBubble)
signal bubble_destroyed(destroyed_bubble : BaseBubble)
signal apply_effect_to_bubble_slot(effect : BaseEffect, bubble_slot_coords : Vector2i)
signal rotate_bubble_grid(bubble_grid : BubbleGridManager, rotation_change : float)
signal scoring_bubbles(score_number : ScoreNumber)
#signal reparent_requested(bubble : BaseBubble, new_parent : StringName)

## Set of Bubbles Scored
func connect_scoring_bubbles(callable : Callable):
	self.scoring_bubbles.connect(callable)
func emit_scoring_bubbles(_score_number):
	scoring_bubbles.emit(_score_number)

## Bubble Destroyed
func connect_rotate_bubble_grid(callable : Callable):
	self.rotate_bubble_grid.connect(callable)
func emit_rotate_bubble_grid(_bubble_grid, _rotation_change):
	rotate_bubble_grid.emit(_bubble_grid, _rotation_change)

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
func emit_bubble_shot(shot_bubble):
	bubble_shot.emit(shot_bubble)

# Apply Effect to Bubble Slot
func connect_apply_effect_to_bubble_slot(callable : Callable):
	self.apply_effect_to_bubble_slot.connect(callable)
func emit_apply_effect_to_bubble_slot(_effect_callable, _bubble_slot_coords):
	apply_effect_to_bubble_slot.emit(_effect_callable, _bubble_slot_coords)
