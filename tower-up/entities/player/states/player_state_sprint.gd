class_name PlayerStateSprint
extends State


@export_group(ExportGroups.ATRIBUTES)
@export var sprint_speed_multiplier: float = 1.5

@export_group(ExportGroups.BODIES)
@export var character_body: CharacterBody3D

@export_group(ExportGroups.COMPONENTS)
@export var motion_component: MotionComponent

@export_group(ExportGroups.STATES)
@export var idle_state: PlayerStateIdle
@export var run_state: PlayerStateRun
@export var crouch_slide_state: PlayerStateCrouchSlide
@export var jump_state: PlayerStateJump
@export var fall_state: PlayerStateFall

@export_group(ExportGroups.ANIMATION)
@export var animation_player: AnimationPlayer

var motion: MotionData


func _ready() -> void:
	assert(idle_state != null)
	local_function_transitions.create_and_add(idle_state, _to_idle)

	assert(run_state != null )
	local_function_transitions.create_and_add(run_state, _to_run)

	assert(crouch_slide_state != null)
	local_function_transitions.create_and_add(crouch_slide_state, _to_crouch_slide)

	assert(jump_state != null )
	local_function_transitions.create_and_add(jump_state, _to_jump)

	assert(fall_state != null )
	local_function_transitions.create_and_add(fall_state, _to_fall)
	
	assert(character_body != null)
	assert(animation_player != null)
	assert(motion_component != null)
	assert(motion_component.data != null)

	motion = motion_component.data


func _on_enter() -> void:
	animation_player.play("running")


func _state_physics_process(delta: float) -> void:
	assert(character_body != null)
	assert(motion != null)

	var direction: Vector3 = InputComponent.get_relative_motion_input_direction(
		CameraSystem.active_controller
	)

	AnimationComponent.rotate_horizontaly(
		character_body,
		direction,
		delta
	)

	MotionComponent.move_character_horizontaly(
		character_body,
		direction,
		motion.base_speed * sprint_speed_multiplier,
		motion.acceleration * delta
	)

	MotionComponent.apply_gravity(
		character_body,
		motion.gravity * delta,
		motion.fall_speed
	)

	character_body.move_and_slide()
	# MotionComponent.character_push_rigidbody(
	# 	character_body,
	# 	delta,
	# 	motion.push_force
	# )


func _to_idle() -> DecisionResult:
	var input_direction: Vector3 = InputComponent.get_motion_input_direction()
	return DecisionResult.create(input_direction == Vector3.ZERO)


func _to_run() -> DecisionResult:
	var sprint_input: bool = Input.is_action_pressed(InputActions.SPRINT)
	return DecisionResult.create(not sprint_input)
	

func _to_crouch_slide() -> DecisionResult:
	assert(InputMap.has_action(InputActions.CROUCH))
	var crouch_input: bool = Input.is_action_pressed(InputActions.CROUCH)
	return DecisionResult.create(crouch_input)


func _to_jump() -> DecisionResult:
	var jump_button: bool = Input.is_action_just_pressed(InputActions.JUMP)
	return DecisionResult.create(jump_button)


func _to_fall() ->DecisionResult:
	var is_falling: bool = character_body.velocity.y < 0
	return DecisionResult.create(is_falling)
