class_name LabelSliderContainer
extends Container


@export var lpad_value: int = 3
@export var lpad_symbol: StringName = " "

@export var label: Label
@export var slider: Slider


func _ready() -> void:
	assert(label != null)
	assert(slider != null)
	assert(is_ancestor_of(label))
	assert(is_ancestor_of(slider))

	slider.value_changed.connect(_on_slider_value_changed)
	assert(slider.value_changed.is_connected(_on_slider_value_changed))

	_update_label_text()


func _update_label_text() -> void:
	label.text = str(slider.value as int).lpad(lpad_value, lpad_symbol)


func _on_slider_value_changed(_value: float) -> void:
	_update_label_text()
