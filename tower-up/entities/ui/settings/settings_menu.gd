extends Control


@export var focus_on_ready: Control


func _ready() -> void:
	focus_on_ready.grab_focus()


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		UISystemAutoload.close_top_menu()
