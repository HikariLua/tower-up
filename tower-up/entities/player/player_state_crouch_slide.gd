class_name PlayerStateCrouchSlide
extends State


@export_group(ExportGroups.ATRIBUTES)
@export var lateral_speed_multiplier: float = 0.2
@export var forward_delta_multiplier: float = 0.3

@export_group(ExportGroups.BODIES)
@export var character_body: CharacterBody3D

@export_group(ExportGroups.COMPONENTS)
@export var motion_component: MotionComponent

@export_group(ExportGroups.STATES)
@export var idle_state: PlayerStateIdle
@export var roll_state: PlayerStateRoll
@export var crouch_state: PlayerStateCrouch
@export var fall_state: PlayerStateFall
@export var z_jump_state: PlayerStateZJump

@export_group(ExportGroups.ANIMATION)
@export var animation_player: AnimationPlayer

var motion: MotionData

var _steer_struct: SteerStruct = SteerStruct.new()


func _ready() -> void:
	assert(idle_state != null)
	local_function_transitions.create_and_add(idle_state, _to_idle)

	assert(roll_state != null)
	local_function_transitions.create_and_add(roll_state, _to_roll)

	assert(crouch_state != null)
	local_function_transitions.create_and_add(crouch_state, _to_crouch)

	assert(z_jump_state != null)
	local_function_transitions.create_and_add(z_jump_state, _to_z_jump)

	assert(fall_state != null)
	local_function_transitions.create_and_add(fall_state, _to_fall)
	
	assert(character_body != null)
	assert(animation_player != null)
	assert(motion_component != null)
	assert(motion_component.data != null)

	motion = motion_component.data


func _on_enter() -> void:
	var horizontal_velocity: Vector3 = MotionComponent.get_horizontal_velocity(
		character_body.velocity
	)

	_steer_struct.forward_direction = MotionComponent.get_foward_direction(
		character_body.velocity
	)
	_steer_struct.forward_speed = MotionComponent.get_velocity_speed(horizontal_velocity)

	_steer_struct.right_direction = MotionComponent.get_right_direction(
		_steer_struct.forward_direction
	)

	_steer_struct.lateral_speed = MotionComponent.get_lateral_speed(
		horizontal_velocity,
		_steer_struct.right_direction
	)

	animation_player.play("crouch")


func _state_physics_process(delta: float) -> void:
	assert(character_body != null)
	assert(motion != null)

	var direction: Vector3 = InputComponent.get_relative_motion_input_direction(
		CameraSystem.active_controller
	)

	MotionComponent.steer_horizontal_movement(
		character_body,
		direction,
		motion.base_speed * lateral_speed_multiplier,
		motion.base_delta,
		_steer_struct
	)

	_steer_struct.forward_speed = move_toward(
		_steer_struct.forward_speed,
		0,
		motion.base_delta * forward_delta_multiplier * delta
	)
	_steer_struct.lateral_speed = move_toward(
		_steer_struct.lateral_speed,
		0,
		motion.base_delta * forward_delta_multiplier * delta
	)

	MotionComponent.apply_gravity(
		character_body,
		motion.gravity * delta,
		motion.fall_speed
	)

	character_body.move_and_slide()


func _to_idle() -> DecisionResult:
	assert(InputMap.has_action(InputActions.CROUCH))
	var crouch_input: bool = Input.is_action_pressed(InputActions.CROUCH)
	return DecisionResult.create(not crouch_input)


func _to_roll() -> DecisionResult:
	assert(InputMap.has_action(InputActions.SPRINT))
	var sprint_input: bool = Input.is_action_just_pressed(InputActions.SPRINT)
	return DecisionResult.create(sprint_input)
	

func _to_crouch() -> DecisionResult:
	var is_moving: bool = _steer_struct.forward_speed <= 0
	return DecisionResult.create(is_moving)


func _to_z_jump() -> DecisionResult:
	assert(InputMap.has_action(InputActions.CROUCH))
	assert(InputMap.has_action(InputActions.JUMP))

	var jump_input: bool = Input.is_action_just_pressed(InputActions.JUMP)
	var crouch_input: bool = Input.is_action_pressed(InputActions.CROUCH)
	return DecisionResult.create(crouch_input and jump_input)
	

func _to_fall() -> DecisionResult:
	return DecisionResult.create(character_body.velocity.y < 0)	
