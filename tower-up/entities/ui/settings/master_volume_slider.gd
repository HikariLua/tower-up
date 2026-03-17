extends HSlider


func _ready() -> void:
	value_changed.connect(_on_master_slider_value_changed)
	assert(value_changed.is_connected(_on_master_slider_value_changed))

	value = SettingsAutoload.master_volume


func _on_master_slider_value_changed(new_value: float) -> void:
	SettingsAutoload.master_volume = new_value as int
