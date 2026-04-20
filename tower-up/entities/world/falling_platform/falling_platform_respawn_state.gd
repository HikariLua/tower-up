class_name FallingPlatformRespawnState
extends State


const RESPAWN_ANIMATION: StringName = "respawn"


@export_group(ExportGroups.NODES)
@export var animation_player: AnimationPlayer
@export var state_machine: StateMachine
@export var platform: AnimatableBody3D

@export_group(ExportGroups.STATES)
@export var idle_state: FallingPlatformIdleState

var _original_position: Vector3 = Vector3.ZERO


func _ready() -> void:
	assert(animation_player != null)
	assert(idle_state != null)
	assert(platform != null)

	_original_position = platform.global_position


func _on_enter() -> void:
	assert(animation_player.has_animation(RESPAWN_ANIMATION))
	animation_player.play(RESPAWN_ANIMATION)

	platform.global_position = _original_position
	state_machine.transition_state(idle_state)
