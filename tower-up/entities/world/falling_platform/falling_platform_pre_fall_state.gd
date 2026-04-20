class_name FallingPlatformPreFallState
extends State


const PRE_FALL_ANIMATION: StringName = "pre_fall"


@export_group(ExportGroups.NODES)
@export var state_machine: StateMachine
@export var animation_player: AnimationPlayer
@export var pre_fall_timer: Timer

@export_group(ExportGroups.ATRIBUTES)
@export var pre_fall_duration: float = 0

@export_group(ExportGroups.STATES)
@export var fall_state: FallingPlatformFallState


func _ready() -> void:
	assert(animation_player != null)
	assert(state_machine != null)
	assert(fall_state != null)

	assert(pre_fall_timer != null)
	pre_fall_timer.timeout.connect(_on_pre_fall_timer_timout)
	assert(pre_fall_timer.timeout.is_connected(_on_pre_fall_timer_timout))


func _on_enter() -> void:
	assert(animation_player.has_animation(PRE_FALL_ANIMATION))
	animation_player.play(PRE_FALL_ANIMATION)

	assert(pre_fall_timer != null)
	pre_fall_timer.start(pre_fall_duration)


func _on_pre_fall_timer_timout() -> void:
	state_machine.transition_state(fall_state)
