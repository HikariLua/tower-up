class_name FollowingPlayerCameraState
extends State

@export var camera_controller: Camera3DController

@export var player: CharacterBody3D

const camera_default_height: float = 5.8;

const offset_from_player_z: float = 5.0;

func _ready() -> void:
	assert(camera_controller != null)

func _on_enter() -> void:
	camera_controller.position.y = camera_default_height;
	
func _state_physics_process(delta: float) -> void:
	
	# Segue a altura do player
	camera_controller.position.y += (player.position.y - camera_controller.position.y + camera_default_height) * delta
	# Faz um deslize a posição x do player, reduzindo a partir da distancia entre camera e player
	camera_controller.position.x += (player.position.x - camera_controller.position.x) * delta;
	
	camera_controller.position.z += ((player.position.z + offset_from_player_z) - camera_controller.position.z) * 10 * delta;
	
	# Ambos multiplicado por delta para suavidade
	
	
