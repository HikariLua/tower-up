extends HSlider


func _ready() -> void:
	value_changed.connect(_on_sfx_slider_value_changed)
	assert(value_changed.is_connected(_on_sfx_slider_value_changed))

	value = SettingsAutoload.sfx_volume


func _on_sfx_slider_value_changed(new_value: float) -> void:
	SettingsAutoload.sfx_volume = new_value as int
