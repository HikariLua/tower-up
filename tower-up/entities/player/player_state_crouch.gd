class_name PlayerStateCrouch
extends State


@export_group(ExportGroups.ATRIBUTES)
@export var crouch_speed_multiplier: float = 0.2

@export_group(ExportGroups.BODIES)
@export var character_body: CharacterBody3D

@export_group(ExportGroups.COMPONENTS)
@export var motion_component: MotionComponent

@export_group(ExportGroups.STATES)
@export var idle_state: PlayerStateIdle
@export var roll_state: PlayerStateRoll
@export var fall_state: PlayerStateFall
@export var backflip_state: PlayerStateBackflip

@export_group(ExportGroups.ANIMATION)
@export var animation_player: AnimationPlayer

@export_group("RayCast")
@export var raycast: RayCast3D

var motion: MotionData


func _ready() -> void:
	assert(idle_state != null)
	local_function_transitions.create_and_add(idle_state, _to_idle)

	assert(roll_state != null)
	local_function_transitions.create_and_add(roll_state, _to_roll)

	assert(fall_state != null)
	local_function_transitions.create_and_add(fall_state, _to_fall)

	assert(fall_state != null)
	local_function_transitions.create_and_add(backflip_state, _to_backflip)
	
	assert(character_body != null)
	assert(animation_player != null)
	assert(motion_component != null)
	assert(motion_component.data != null)
	assert(raycast != null)

	motion = motion_component.data


func _on_enter() -> void:
	animation_player.play("crouch")


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
		motion.base_speed * crouch_speed_multiplier,
		motion.acceleration * delta
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
	var has_object_above: bool = raycast.is_colliding()
	return DecisionResult.create(not crouch_input && not has_object_above)


func _to_roll() -> DecisionResult:
	assert(InputMap.has_action(InputActions.SPRINT))
	var sprint_input: bool = Input.is_action_just_pressed(InputActions.SPRINT)
	return DecisionResult.create(sprint_input)


func _to_backflip() -> DecisionResult:
	assert(InputMap.has_action(InputActions.JUMP))
	var jump_input: bool = Input.is_action_pressed(InputActions.JUMP)
	return DecisionResult.create(jump_input)
	

func _to_fall() -> DecisionResult:
	return DecisionResult.create(character_body.velocity.y < 0)	
