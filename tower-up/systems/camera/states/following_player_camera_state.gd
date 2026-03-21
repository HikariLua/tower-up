class_name FollowingPlayerCameraState
extends State

@export var camera_controller: Camera3DController

@export var player: CharacterBody3D

const CAMERA_DEFAULT_HEIGHT: float = 5.8;
const DEFAULT_ROTATION: Vector3 = Vector3(0,0,0)
const offset_from_player_z: float = 10;

func _ready() -> void:
	assert(camera_controller != null)
	assert(player != null)
	

func _on_enter() -> void:
	camera_controller.rotation = Vector3(0, 0, 0)
	camera_controller.position = player.position
	camera_controller.position.y += CAMERA_DEFAULT_HEIGHT
	camera_controller.position.z += offset_from_player_z
	camera_controller.rotate(Vector3.RIGHT, -.5)
	
func _state_physics_process(delta: float) -> void:
	
	# Segue a altura do player
	camera_controller.position.y += (player.position.y - camera_controller.position.y + CAMERA_DEFAULT_HEIGHT) * delta
	# Faz um deslize a posição x do player, reduzindo a partir da distancia entre camera e player
	camera_controller.position.x += (player.position.x - camera_controller.position.x) * delta;
		
	# Ambos multiplicado por delta para suavidade
	camera_controller.position.z += ((player.position.z + offset_from_player_z) - camera_controller.position.z) * 10 * delta;

	
