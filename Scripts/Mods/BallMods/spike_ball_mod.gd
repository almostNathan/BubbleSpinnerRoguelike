extends BaseBallMod
class_name SpikeBallMod

var spike_effect_scene : PackedScene = preload("res://Scenes/Effects/spike_ball_effect.tscn")
var num_spikes = 6
var spike_array :  = []

func attach(new_ball : BaseBall) -> void:
	super(new_ball)
	new_ball.add_child(self)
	ball.on_destroy.connect(trigger_spikes)
	add_spike_effects()

func add_spike_effects():
	for i in len(Util.RELATIVE_POSITIONS_ARRAY):
		var spike_effect : SpikeBallEffect = spike_effect_scene.instantiate()
		spike_array.append(spike_effect)
		spike_effect.target_relative_position = Util.RELATIVE_POSITIONS_ARRAY[i]
		spike_effect.sprite_pos = Vector2(self.ball.BALL_RADIUS, 0)
		spike_effect.rotate(float(i)/float(num_spikes) * 2 * PI)
		self.ball.add_child(spike_effect)
	self.ball

func trigger_spikes(ball : BaseBall) -> void:
	if self.ball.slot == null:
		pass
	else:
		for spike : SpikeBallEffect in spike_array:
			#setting the start position
			var target_coords = self.ball.slot.grid_position + spike.target_relative_position
			SignalHub.emit_apply_effect_to_ball_slot(spike, target_coords)
	queue_free()
