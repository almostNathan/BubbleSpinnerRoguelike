extends BaseBubbleMod
class_name SpikeBubbleMod

var spike_effect_scene : PackedScene = preload("res://Scenes/Effects/spike_bubble_effect.tscn")
var num_spikes = 6
var spike_dict : Dictionary[Vector2i, SpikeBubbleEffect] = {}

func attach(new_bubble : BaseBubble) -> void:
	super(new_bubble)
	new_bubble.add_child(self)
	bubble.on_destroy.connect(trigger_spikes)
	add_spike_effects()

func add_spike_effects():
	for i in len(Util.RELATIVE_POSITIONS_ARRAY):
		var spike_effect : SpikeBubbleEffect = spike_effect_scene.instantiate()
		spike_dict[Util.RELATIVE_POSITIONS_ARRAY[i]] = spike_effect
		spike_effect.sprite_pos = Vector2(self.bubble.BUBBLE_RADIUS, 0)
		spike_effect.rotate(float(i)/float(num_spikes) * 2 * PI)
		self.bubble.add_child(spike_effect)

func trigger_spikes(target_bubble : BaseBubble) -> void:
	if self.bubble.slot == null:
		pass
	else:
		for relative_position in Util.RELATIVE_POSITIONS_ARRAY:
			#setting the start position
			var spike : SpikeBubbleEffect = spike_dict[relative_position]
			var target_coords = self.bubble.slot.grid_position + relative_position
			SignalHub.emit_apply_effect_to_bubble_slot(spike, target_coords)
	self.queue_free()
