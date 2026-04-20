class_name FallingPlatformDestroyedState
extends State


const DESTROYED_ANIMATION: StringName = "destroyed"


@export_group(ExportGroups.NODES)
@export var animation_player: AnimationPlayer
@export var state_machine: StateMachine
@export var platform_collision: CollisionShape3D
@export var destroyed_timer: Timer

@export_group(ExportGroups.ATRIBUTES)
@export var destroyed_duration: float = 0

@export_group(ExportGroups.STATES)
@export var respawn_state: FallingPlatformRespawnState


func _ready() -> void:
	assert(animation_player != null)
	assert(state_machine != null)
	assert(respawn_state != null)
	assert(platform_collision != null)

	assert(destroyed_timer != null)
	destroyed_timer.timeout.connect(_on_respawn_timer_timout)
	assert(destroyed_timer.timeout.is_connected(_on_respawn_timer_timout))


func _on_enter() -> void:
	_toggle_platform_collision.call_deferred(false)

	assert(animation_player.has_animation(DESTROYED_ANIMATION))
	animation_player.play(DESTROYED_ANIMATION)

	assert(destroyed_timer != null)
	destroyed_timer.start(destroyed_duration)


func _on_exit() -> void:
	_toggle_platform_collision.call_deferred(true)


func _toggle_platform_collision(value: bool) -> void:
	platform_collision.disabled = not value


func _on_respawn_timer_timout() -> void:
	state_machine.transition_state(respawn_state)
