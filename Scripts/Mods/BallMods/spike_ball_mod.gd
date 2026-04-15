extends BaseBallMod
class_name SpikeBallMod

var spike_effect_scene : PackedScene = preload("res://Scenes/Effects/spike_ball_effect.tscn")
var num_spikes = 6

func attach(new_ball : BaseBall) -> void:
	super(new_ball)
	new_ball.add_child(self)
	ball.on_destroy.connect(trigger_spikes)
	add_spike_effects()

func add_spike_effects():
	for i in range(num_spikes):
		var spike_effect : SpikeBallEffect = spike_effect_scene.instantiate()
		spike_effect.sprite_pos = Vector2(0, -self.ball.BALL_RADIUS)
		spike_effect.rotate(float(i)/float(num_spikes) * 2 * PI)
		self.ball.add_child(spike_effect)
	self.ball

func trigger_spikes(ball : BaseBall) -> void:
	if ball.slot == null:
		pass
	else:
		var adjacent_slots = ball.slot.get_adjacent_grid_positions()
		for slot in adjacent_slots:
			var spike_effect = spike_effect_scene.instantiate()
			#setting the start position
			SignalHub.emit_apply_effect_to_ball_slot(spike_effect, slot)
	queue_free()
