extends Node2D
class_name RotationTracker



func _on_h_slider_value_changed(value: float) -> void:
	$TextureProgressBar.value = value
