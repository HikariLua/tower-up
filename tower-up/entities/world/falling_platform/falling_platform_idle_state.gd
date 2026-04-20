class_name FallingPlatformIdleState
extends State


const IDLE_ANIMATION: StringName = "RESET"


@export_group(ExportGroups.NODES)
@export var state_machine: StateMachine
@export var area_trigger: Area3D
@export var animation_player: AnimationPlayer

@export_group(ExportGroups.STATES)
@export var pre_fall_state: FallingPlatformPreFallState


func _ready() -> void:
	assert(pre_fall_state != null)

	assert(animation_player != null)
	animation_player.animation_finished.connect(
		_on_animation_player_animation_finished
	)
	assert(
		animation_player.animation_finished.is_connected(
			_on_animation_player_animation_finished
		)
	)

	assert(area_trigger != null)
	area_trigger.body_entered.connect(_on_area_trigger_body_entered)
	assert(area_trigger.body_entered.is_connected(_on_area_trigger_body_entered))


func _on_enter() -> void:
	_toggle_area_trigger.call_deferred(true)


func _on_exit() -> void:
	_toggle_area_trigger.call_deferred(false)


func _toggle_area_trigger(value: bool) -> void:
	area_trigger.monitoring = value


func _on_area_trigger_body_entered(_body: Node3D) -> void:
	state_machine.transition_state(pre_fall_state)


func _on_animation_player_animation_finished(animation_name: StringName) -> void:
	if animation_name != FallingPlatformRespawnState.RESPAWN_ANIMATION:
		return

	assert(animation_player.has_animation(IDLE_ANIMATION))
	animation_player.play(IDLE_ANIMATION)
