extends Node


const IDLE_ANIMATION: StringName = "RESET"


@export_group(ExportGroups.STATES)
@export var idle_state: FallingPlatformIdleState


func _ready() -> void:
	assert(idle_state != null)
	assert(respawn_state != null)

	assert(respawn_timer != null)
	respawn_timer.timeout.connect(_on_respawn_timer_timout)
	assert(respawn_timer.timeout.is_connected(_on_respawn_timer_timout))


func _on_respawn_timer_timout() -> void:
	state_machine.transition_state(respawn_state)
	respawn_timer.start(respawn_duration)
