extends Control


@export var focus_on_ready: Control
@export var button_2: Button

var settings: PackedScene = preload("uid://cadtlgefbxw8c")

func _ready() -> void:
	focus_on_ready.grab_focus()
	button_2.pressed.connect(_on_button_2_pressed)


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_down"):
		print("down")
	if Input.is_action_just_pressed("ui_cancel"):
		UISystemAutoload.close_top_menu()
		

func _on_button_2_pressed() -> void:
	UISystemAutoload.open_menu(settings)
