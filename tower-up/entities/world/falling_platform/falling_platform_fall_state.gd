class_name FallingPlatformFallState
extends State


const FALL_ANIMATION: StringName = "RESET"


@export_group(ExportGroups.NODES)
@export var animation_player: AnimationPlayer
@export var state_machine: StateMachine
@export var platform: AnimatableBody3D
@export var fall_timer: Timer

@export_group(ExportGroups.ATRIBUTES)
@export var fall_duration: float = 0
@export var fall_speed: float = 0
@export var fall_acceleration: float = 0

@export_group(ExportGroups.STATES)
@export var destroyed_state: FallingPlatformDestroyedState

var _current_speed: float = 0


func _ready() -> void:
	assert(animation_player != null)
	assert(state_machine != null)
	assert(platform != null)
	assert(destroyed_state != null)

	assert(fall_timer != null)
	fall_timer.timeout.connect(_on_fall_timer_timout)
	assert(fall_timer.timeout.is_connected(_on_fall_timer_timout))


func _on_enter() -> void:
	assert(animation_player.has_animation(FALL_ANIMATION))
	animation_player.play(FALL_ANIMATION)

	fall_timer.start(fall_duration)


func _state_physics_process(delta: float) -> void:
	_current_speed = move_toward(
		_current_speed,
		fall_speed,
		fall_acceleration * delta
	)

	platform.global_position.y -= _current_speed


func _on_exit() -> void:
	_current_speed = 0


func _on_fall_timer_timout() -> void:
	state_machine.transition_state(destroyed_state)
