extends Node2D
class_name BubbleQueue

var current_queue : Array[BaseBubble] = []

func get_next_bubble() -> BaseBubble:
	if current_queue.is_empty():
		reload_current_queue()
	return current_queue.pop_front()

func add_mod_to_all_bubbles(new_mod : BaseBubbleMod) -> void:
	print("bubble queue : add mods to bubbles")
	for bubble in current_queue:
		bubble.add_mod(new_mod.duplicate())

func reload_current_queue() -> void:
	for i in range(10):
		var new_bubble = preload("res://Scenes/base_bubble.tscn").instantiate()
		var new_type : String = BubbleTypes.types.keys().pick_random()
		new_bubble.add_type(new_type, BubbleTypes.types[new_type]['color'])
		current_queue.append(new_bubble)
	add_mod_to_all_bubbles_random(preload("res://Scenes/Mods/BubbleMods/spike_bubble_mod.tscn").instantiate(), .5)

func add_mod_to_all_bubbles_random(new_mod : BaseBubbleMod, chance_to_add : float):
	for bubble in current_queue:
		if randf() < chance_to_add:
			bubble.add_mod(new_mod.duplicate())
	
	
