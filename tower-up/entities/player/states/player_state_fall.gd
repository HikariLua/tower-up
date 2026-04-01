class_name PlayerStateFall
extends State


@export_group(ExportGroups.BODIES)
@export var character_body: CharacterBody3D

@export_group(ExportGroups.COMPONENTS)
@export var motion_component: MotionComponent

@export_group(ExportGroups.STATES)
@export var idle_state: PlayerStateIdle
@export var run_state: PlayerStateRun

@export_group(ExportGroups.ANIMATION)
@export var animation_player: AnimationPlayer

var motion: MotionData

var _max_fall_horizontal_speed: float = 0


func _ready() -> void:
	assert(idle_state != null)
	local_function_transitions.create_and_add(idle_state, _to_idle)

	assert(run_state != null)
	local_function_transitions.create_and_add(run_state, _to_run)
	
	assert(character_body != null)
	assert(animation_player != null)
	assert(motion_component != null)
	assert(motion_component.data != null)

	motion = motion_component.data


func _on_enter() -> void:
	var horizontal_speed: float = MotionComponent.get_horizontal_speed(character_body.velocity)
	_max_fall_horizontal_speed = max(horizontal_speed, motion.base_speed)

	animation_player.play("RESET")
	

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

	MotionComponent.move_character_horizontaly_with_momentum(
		character_body,
		direction,
		motion.base_speed,
		_max_fall_horizontal_speed,
		motion.air_acceleration * delta
	)

	MotionComponent.apply_gravity(
		character_body,
		motion.gravity * delta,
		motion.fall_speed
	)

	character_body.move_and_slide()


func _to_idle() -> DecisionResult:
	var input_direction: Vector3 = InputComponent.get_motion_input_direction()
	var on_ground: bool = character_body.is_on_floor()
	return DecisionResult.create(input_direction == Vector3.ZERO and on_ground)	


func _to_run() -> DecisionResult:
	var input_direction: Vector3 = InputComponent.get_motion_input_direction()
	var on_ground: bool = character_body.is_on_floor()
	return DecisionResult.create(input_direction != Vector3.ZERO and on_ground)
