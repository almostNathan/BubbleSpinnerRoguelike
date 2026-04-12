extends BaseBallMod
class_name SpikeBallMod

var spike_effect_scene : PackedScene = preload("res://Scenes/Effects/ball_spike_effect.tscn")

func attach(new_ball : BaseBall) -> void:
	super(new_ball)
	ball.on_destroy.connect(trigger_spikes)

func trigger_spikes() -> void:
	#get adjacent positions
	var adjacent_slots = ball.slot.get_adjacent_grid_positions()
	if ball.slot == null:
		pass
	else:
		SignalHub.emit_apply_effect_to_ball_slot(spike_effect_scene.instantiate(), ball.slot.grid_position)
