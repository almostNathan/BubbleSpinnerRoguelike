extends BaseBubbleMod
class_name SpikeBubbleMod

var spike_effect_scene : PackedScene = preload("res://Scenes/Effects/spike_bubble_effect.tscn")
var num_spikes = 6
var spike_array :  = []

func attach(new_bubble : BaseBubble) -> void:
	super(new_bubble)
	new_bubble.add_child(self)
	bubble.on_destroy.connect(trigger_spikes)
	add_spike_effects()

func add_spike_effects():
	for i in len(Util.RELATIVE_POSITIONS_ARRAY):
		var spike_effect : SpikeBubbleEffect = spike_effect_scene.instantiate()
		spike_array.append(spike_effect)
		spike_effect.target_relative_position = Util.RELATIVE_POSITIONS_ARRAY[i]
		spike_effect.sprite_pos = Vector2(self.bubble.BUBBLE_RADIUS, 0)
		spike_effect.rotate(float(i)/float(num_spikes) * 2 * PI)
		self.bubble.add_child(spike_effect)
	self.bubble

func trigger_spikes(bubble : BaseBubble) -> void:
	if self.bubble.slot == null:
		pass
	else:
		for spike : SpikeBubbleEffect in spike_array:
			#setting the start position
			var target_coords = self.bubble.slot.grid_position + spike.target_relative_position
			SignalHub.emit_apply_effect_to_bubble_slot(spike, target_coords)
	queue_free()
