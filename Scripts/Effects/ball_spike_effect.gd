extends BaseEffect
class_name SpikeBallEffect

func apply_effect(grid_slot : BallGridSlot) -> void:
	var adjacent_slots = grid_slot.get_adjacent_grid_positions()
	
