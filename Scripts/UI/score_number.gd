extends Node2D
class_name ScoreNumber

@onready var label_container = $Container
@onready var label = $Container/Label


func set_values_and_animate(value, pos):
	label.text = str(value)
	self.global_position = pos
	var fade_tween = get_tree().create_tween()
	fade_tween.tween_property(label_container, "modulate:a", 0, 1)
	fade_tween.finished.connect(remove)


	#var tween = get_tree().create_tween()
	#var end_pos = Vector2(randf_range(-spread, spread), -height) + start_pos
	#var tween_length = animation_player.get_animation("damage_number_animation").length
	
	#tween.tween_property(label_container, "position", end_pos, tween_length).from(start_pos)


func remove():
	if is_inside_tree():
		get_parent().remove_child(self)

func set_color(new_color : Color):
	var new_label_settings = label.label_settings.duplicate()
	new_label_settings.font_color = new_color
	label.label_settings = new_label_settings
	
func set_style(style_settings : Dictionary):
	var new_label_settings = label.label_settings.duplicate()

	if style_settings['color'] != null:
		new_label_settings.font_color = style_settings['color']

	label.label_settings = new_label_settings
