class_name FixedOnPlayerCameraState
extends State

@export var camera_controller: Camera3DController

@export var player : CharacterBody3D

func _ready() -> void:
	assert(camera_controller != null)
	
func _state_physics_process(delta: float) -> void:
	camera_controller.position.y = player.position.y + 40 * delta;
	camera_controller.position.x += (player.position.x - camera_controller.position.x) * delta;
