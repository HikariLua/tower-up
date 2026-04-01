class_name Camera3DSystem
extends Node


var active_controller: Camera3DController
var active_camera: Camera3D


func _ready() -> void:
	active_camera = get_viewport().get_camera_3d()
	assert(active_camera != null)

	active_controller = active_camera.get_parent() as Camera3DController
	assert(active_controller != null)
