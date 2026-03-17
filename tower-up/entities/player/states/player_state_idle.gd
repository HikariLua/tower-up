class_name PlayerStateIdle
extends State


@export_group(ExportGroups.BODIES)
@export var character_body: CharacterBody3D

@export_group(ExportGroups.COMPONENTS)
@export var motion_component: MotionComponent

@export_group(ExportGroups.STATES)
@export var run_state: PlayerStateRun

var motion: MotionData


func _ready() -> void:
	assert(run_state != null)
	local_function_transitions.create_and_add(run_state, _to_run)

	assert(character_body != null)
	assert(motion_component != null)
	assert(motion_component.data != null)

	motion = motion_component.data


func _state_physics_process(delta: float) -> void:
	assert(character_body != null)
	assert(motion != null)

	character_body.velocity = MotionComponent.move_character_horizontaly(
		character_body.velocity,
		Vector3.ZERO,
		0,
		motion.friction * delta
	)

	character_body.velocity.y = MotionComponent.apply_gravity(
		motion.gravity,
		character_body
	)

	character_body.move_and_slide()


func _to_run() -> DecisionResult:
	var input_direction: Vector3 = InputComponent.get_motion_input_direction()
	return DecisionResult.create(input_direction != Vector3.ZERO)
