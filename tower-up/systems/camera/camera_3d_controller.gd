class_name Camera3DController
extends Node3D

@export var state_machine: StateMachine

@export var free_camera: FreeRotationCameraState
@export var fixed_camera: FixedYRotationCameraState
@export var follow_camera : FollowingPlayerCameraState

func _ready() -> void:
	assert(state_machine != null)
	assert(free_camera != null)
	assert(fixed_camera != null)
	assert(follow_camera != null)

	state_machine.global_function_transitions.create_and_add(free_camera, _to_free)
	state_machine.global_function_transitions.create_and_add(fixed_camera, _to_fixed)
	state_machine.global_function_transitions.create_and_add(follow_camera, _to_player)


func _to_player() -> DecisionResult:
	return DecisionResult.create(Input.is_action_pressed("debug_camera_1")) # F1


func _to_fixed() -> DecisionResult:
	return DecisionResult.create(Input.is_action_pressed("debug_camera_2")) # F2


func _to_free() -> DecisionResult:
	return DecisionResult.create(Input.is_action_pressed("debug_camera_3")) # F3
#
