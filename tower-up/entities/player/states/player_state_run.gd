class_name PlayerStateRun
extends State


@export_group(ExportGroups.BODIES)
@export var character_body: CharacterBody3D

@export_group(ExportGroups.COMPONENTS)
@export var motion_component: MotionComponent

@export_group(ExportGroups.STATES)
@export var idle_state: PlayerStateIdle

@export var camera_manager: Node3D

var motion: MotionData


func _ready() -> void:
	assert(idle_state != null)
	local_function_transitions.create_and_add(idle_state, _to_idle)

	assert(character_body != null)
	assert(motion_component != null)
	assert(motion_component.data != null)

	motion = motion_component.data


func _state_physics_process(delta: float) -> void:
	assert(character_body != null)
	assert(motion != null)
	assert(camera_manager != null)

	var input_direction: Vector3 = InputComponent.get_motion_input_direction().normalized()
	var direction: Vector3 = camera_manager.transform.basis * input_direction

	character_body.velocity = MotionComponent.move_character_horizontaly(
		character_body.velocity,
		direction,
		motion.max_speed,
		motion.acceleration * delta
	)

	character_body.velocity.y = MotionComponent.apply_gravity(
		motion.gravity,
		character_body
	)

	character_body.move_and_slide()


func _to_idle() -> DecisionResult:
	var input_direction: Vector3 = InputComponent.get_motion_input_direction()
	return DecisionResult.create(input_direction == Vector3.ZERO)
