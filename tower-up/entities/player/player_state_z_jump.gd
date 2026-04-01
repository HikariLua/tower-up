class_name PlayerStateZJump
extends State


@export_group(ExportGroups.ATRIBUTES)
@export var z_jump_impulse: float = 8
@export var z_jump_speed_multiplier: float = 1.5
@export var lateral_speed_multiplier: float = 0.2

@export_group(ExportGroups.BODIES)
@export var character_body: CharacterBody3D

@export_group(ExportGroups.COMPONENTS)
@export var motion_component: MotionComponent

@export_group(ExportGroups.STATES)
@export var idle_state: PlayerStateIdle
@export var crouch_slide_state: PlayerStateCrouchSlide

@export_group(ExportGroups.ANIMATION)
@export var animation_player: AnimationPlayer

var motion: MotionData

var _steer_struct: SteerStruct = SteerStruct.new()


func _ready() -> void:
	assert(idle_state != null)
	local_function_transitions.create_and_add(idle_state, _to_idle)

	assert(crouch_slide_state != null)
	local_function_transitions.create_and_add(crouch_slide_state, _to_crouch_slide)

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
		-character_body.transform.basis.z
	)

	_steer_struct.forward_speed = MotionComponent.get_velocity_speed(horizontal_velocity)
	_steer_struct.forward_speed = max(
		motion.base_speed * z_jump_speed_multiplier,
		_steer_struct.forward_speed
	)

	_steer_struct.right_direction = MotionComponent.get_right_direction(
		_steer_struct.forward_direction
	)

	_steer_struct.lateral_speed = MotionComponent.get_lateral_speed(
		horizontal_velocity,
		_steer_struct.right_direction
	)

	character_body.velocity.y = z_jump_impulse
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


func _to_crouch_slide() -> DecisionResult:
	assert(InputMap.has_action(InputActions.CROUCH))
	var crouch_input: bool = Input.is_action_pressed(InputActions.CROUCH)
	var on_floor: bool = character_body.is_on_floor()

	return DecisionResult.create(on_floor and crouch_input)


func _to_idle() -> DecisionResult:
	assert(InputMap.has_action(InputActions.CROUCH))
	var crouch_input: bool = Input.is_action_pressed(InputActions.CROUCH)
	var on_floor: bool = character_body.is_on_floor()

	return DecisionResult.create(on_floor and not crouch_input)
	
