class_name PlayerStateRun
extends State


@export_group(ExportGroups.BODIES)
@export var character_body: CharacterBody3D

@export_group(ExportGroups.COMPONENTS)
@export var motion_component: MotionComponent

@export_group(ExportGroups.STATES)
@export var idle_state: PlayerStateIdle
@export var jump_state: PlayerStateJump
@export var fall_state: PlayerStateFall

@export var camera_manager: Node3D

var motion: MotionData


func _ready() -> void:
	assert(idle_state != null)
	assert(jump_state != null )
	assert(fall_state != null )
	
	local_function_transitions.create_and_add(idle_state, _to_idle)
	local_function_transitions.create_and_add(jump_state, _to_jump)
	#local_function_transitions.create_and_add(fall_state, _to_fall)

	assert(character_body != null)
	assert(motion_component != null)
	assert(motion_component.data != null)

	motion = motion_component.data

func _on_enter() -> void:
	animation_player.play("running")


func _state_physics_process(delta: float) -> void:
	assert(character_body != null)
	assert(motion != null)
	assert(camera_manager != null)

	var input_direction: Vector3 = InputComponent.get_motion_input_direction().normalized()
	var direction: Vector3 = camera_manager.transform.basis * input_direction

	MotionComponent.move_character_horizontaly(
		character_body,
		direction,
		motion.max_speed,
		motion.acceleration * delta
	)

	MotionComponent.apply_gravity(
		motion.gravity * delta,
		character_body,
		motion.max_fall_velocity
	)

	MotionComponent.character_push_rigidbody(character_body, delta, motion.push_force)


func _to_idle() -> DecisionResult:
	var input_direction: Vector3 = InputComponent.get_motion_input_direction()
	return DecisionResult.create(input_direction == Vector3.ZERO)
	

func _to_jump() -> DecisionResult:
	var jump_button: bool = Input.is_action_just_pressed(InputActions.JUMP)
	return DecisionResult.create(jump_button)


##TODO: adiciona funçao de push (p.s: usar MotionComponent.character_is_pushing)
