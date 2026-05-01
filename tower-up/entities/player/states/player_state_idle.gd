class_name PlayerStateIdle
extends State

const IDLE_ANIMATION: StringName = "RESET"


@export_group(ExportGroups.BODIES)
@export var character_body: CharacterBody3D

@export_group(ExportGroups.COMPONENTS)
@export var motion_component: MotionComponent

@export_group(ExportGroups.STATES)
@export var run_state: PlayerStateRun
@export var sprint_state: PlayerStateSprint
@export var crouch_state: PlayerStateCrouch
@export var jump_state: PlayerStateJump
@export var fall_state: PlayerStateFall

@export_group(ExportGroups.ANIMATION)
@export var animation_player: AnimationPlayer

@export_group(ExportGroups.RAYCASTS)
@export var superior: RayCast3D
@export var frontal: RayCast3D

var motion: MotionData

func _ready() -> void:
	assert(run_state != null)
	local_function_transitions.create_and_add(run_state, _to_run)

	assert(sprint_state != null)
	local_function_transitions.create_and_add(sprint_state, _to_sprint)

	assert(crouch_state != null)
	local_function_transitions.create_and_add(crouch_state, _to_crouch)

	assert(jump_state != null)
	local_function_transitions.create_and_add(jump_state, _to_jump)

	assert(fall_state != null)
	local_function_transitions.create_and_add(fall_state, _to_fall)
	
	assert(character_body != null)
	assert(animation_player != null)
	assert(motion_component != null)
	assert(motion_component.data != null)

	motion = motion_component.data


func _on_enter() -> void:
	animation_player.play("RESET")


func _state_physics_process(delta: float) -> void:
	assert(character_body != null)
	assert(motion != null)

	MotionComponent.move_character_horizontaly(
		character_body,
		Vector3.ZERO,
		0,
		motion.friction * delta
	)

	MotionComponent.apply_gravity(
		character_body,
		motion.gravity * delta,
		motion.fall_speed
	)

	character_body.move_and_slide()


func _to_push() -> DecisionResult:
	var colliding: bool = frontal.is_colliding()
	if colliding:
		var object: CollisionObject3D = frontal.get_collider()
		print("Raycast batendo em: ", object.name) 
	return DecisionResult.create(colliding)

func _to_run() -> DecisionResult:
	var input_direction: Vector3 = InputComponent.get_motion_input_direction()
	return DecisionResult.create(input_direction != Vector3.ZERO)


func _to_sprint() -> DecisionResult:
	assert(InputMap.has_action(InputActions.SPRINT))
	var sprint_input: bool = Input.is_action_pressed(InputActions.SPRINT)
	var input_direction: Vector3 = InputComponent.get_motion_input_direction()
	return DecisionResult.create(input_direction != Vector3.ZERO and sprint_input)


func _to_crouch() -> DecisionResult:
	assert(InputMap.has_action(InputActions.CROUCH))
	var crouch_input: bool = Input.is_action_pressed(InputActions.CROUCH)
	return DecisionResult.create(crouch_input)
	

func _to_jump() -> DecisionResult:
	assert(InputMap.has_action(InputActions.JUMP))
	var jump_button_pressed: bool = Input.is_action_just_pressed(InputActions.JUMP)
	return DecisionResult.create(jump_button_pressed)


func _to_fall() -> DecisionResult:
	return DecisionResult.create(character_body.velocity.y < 0)	
