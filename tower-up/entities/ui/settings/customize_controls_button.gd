extends Button


var customize_menu: PackedScene = preload("uid://biq6sk0pxrl5h")


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	UISystemAutoload.open_menu(customize_menu)
