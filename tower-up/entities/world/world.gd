extends Node3D


var pause_menu: PackedScene = preload("uid://b7myhk4mh5sf3")


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		pass
		#if UISystemAutoload.is_menu_open(pause_menu):
			#return

		#UISystemAutoload.open_menu(pause_menu)
