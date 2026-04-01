class_name PlayerStateRoll
extends State


@export_group(ExportGroups.ATRIBUTES)
@export var lateral_speed_multiplier: float = 0.2
@export var roll_speed_multiplier: float = 1.2
@export var roll_duration: float = 0.25

@export_group(ExportGroups.BODIES)
@export var character_body: CharacterBody3D

@export_group(ExportGroups.COMPONENTS)
@export var motion_component: MotionComponent
@export var roll_timer: Timer

@export_group(ExportGroups.STATES)
@export var idle_state: PlayerStateIdle
@export var crouch_slide_state: PlayerStateCrouchSlide
@export var fall_state: PlayerStateFall
@export var jump_state: PlayerStateJump
@export var z_jump_state: PlayerStateZJump

@export_group(ExportGroups.ANIMATION)
@export var animation_player: AnimationPlayer

var motion: MotionData

var _steer_struct: SteerStruct = SteerStruct.new()
var _roll_finished: bool = false


func _ready() -> void:
	assert(idle_state != null)
	local_function_transitions.create_and_add(idle_state, _to_idle)

	assert(crouch_slide_state != null)
	local_function_transitions.create_and_add(crouch_slide_state, _to_crouch_slide)

	assert(jump_state != null)
	local_function_transitions.create_and_add(jump_state, _to_jump)

	assert(z_jump_state != null)
	local_function_transitions.create_and_add(z_jump_state, _to_z_jump)

	assert(fall_state != null)
	local_function_transitions.create_and_add(fall_state, _to_fall)
	
	assert(character_body != null)
	assert(animation_player != null)

	assert(roll_timer != null)
	roll_timer.one_shot = true
	roll_timer.timeout.connect(_on_roll_timer_timeout)
	assert(roll_timer.timeout.is_connected(_on_roll_timer_timeout))

	assert(motion_component != null)
	assert(motion_component.data != null)
	motion = motion_component.data


func _on_enter() -> void:
	_steer_struct.forward_direction = MotionComponent.get_foward_direction(
		-character_body.transform.basis.z
	)

	var horizontal_velocity: Vector3 = (
		_steer_struct.forward_direction *
		motion.base_speed *
		roll_speed_multiplier 
	)

	_steer_struct.forward_speed = MotionComponent.get_velocity_speed(
		horizontal_velocity
	)

	_steer_struct.right_direction = MotionComponent.get_right_direction(
		_steer_struct.forward_direction
	)

	_steer_struct.lateral_speed = MotionComponent.get_lateral_speed(
		horizontal_velocity,
		_steer_struct.right_direction
	)

	character_body.velocity.x = horizontal_velocity.x
	character_body.velocity.z = horizontal_velocity.z

	roll_timer.start(roll_duration)
	animation_player.play("RESET")


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

	MotionComponent.apply_gravity(
		character_body,
		motion.gravity * delta,
		motion.fall_speed
	)

	character_body.move_and_slide()


func _on_exit() -> void:
	_roll_finished = false
	roll_timer.stop()


func _on_roll_timer_timeout() -> void:
	_roll_finished = true

	
func _to_idle() -> DecisionResult:
	assert(InputMap.has_action(InputActions.CROUCH))
	var crouch_input: bool = Input.is_action_pressed(InputActions.CROUCH)
	return DecisionResult.create(not crouch_input and _roll_finished)


func _to_crouch_slide() -> DecisionResult:
	assert(InputMap.has_action(InputActions.CROUCH))
	var crouch_input: bool = Input.is_action_pressed(InputActions.CROUCH)
	return DecisionResult.create(crouch_input and _roll_finished)


func _to_z_jump() -> DecisionResult:
	assert(InputMap.has_action(InputActions.CROUCH))
	assert(InputMap.has_action(InputActions.JUMP))

	var jump_input: bool = Input.is_action_just_pressed(InputActions.JUMP)
	var crouch_input: bool = Input.is_action_pressed(InputActions.CROUCH)
	return DecisionResult.create(crouch_input and jump_input)
	

func _to_jump() -> DecisionResult:
	assert(InputMap.has_action(InputActions.CROUCH))
	assert(InputMap.has_action(InputActions.JUMP))

	var jump_input: bool = Input.is_action_just_pressed(InputActions.JUMP)
	var crouch_input: bool = Input.is_action_pressed(InputActions.CROUCH)
	return DecisionResult.create(not crouch_input and jump_input)


func _to_fall() -> DecisionResult:
	return DecisionResult.create(character_body.velocity.y < 0)	
