extends HSlider


func _ready() -> void:
	value_changed.connect(_on_camera_sensitivity_slider_value_changed)
	assert(value_changed.is_connected(_on_camera_sensitivity_slider_value_changed))

	value = SettingsAutoload.camera_sensitivity


func _on_camera_sensitivity_slider_value_changed(new_value: float) -> void:
	SettingsAutoload.camera_sensitivity = new_value as int
