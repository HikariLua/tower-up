extends HSlider


func _ready() -> void:
	value_changed.connect(_on_music_slider_value_changed)
	assert(value_changed.is_connected(_on_music_slider_value_changed))

	value = SettingsAutoload.music_volume


func _on_music_slider_value_changed(new_value: float) -> void:
	SettingsAutoload.music_volume = new_value as int
