class_name PlayerStatePush
extends State


@export_group(ExportGroups.BODIES)
@export var character_body: CharacterBody3D

@export_group(ExportGroups.COMPONENTS)
@export var motion_component: MotionComponent

@export_group(ExportGroups.STATES)
@export var idle_state: PlayerStateIdle
@export var run_state: PlayerStateRun
@export var jump_state: PlayerStateJump
@export var fall_state: PlayerStateFall

@export_group(ExportGroups.ANIMATION)
@export var animation_player: AnimationPlayer

@export_group(ExportGroups.RAYCASTS)
@export var superior: RayCast3D
@export var frontal: RayCast3D

@export var push_force: int = 500


var motion: MotionData


func _ready() -> void:
	assert(idle_state != null)
	local_function_transitions.create_and_add(idle_state, _to_idle)

	#assert(sprint_state != null)
	#local_function_transitions.create_and_add(sprint_state, _to_sprint)

	#assert(crouch_slide_state != null)
	#local_function_transitions.create_and_add(crouch_slide_state, _to_crouch_slide)

	assert(run_state != null)
	local_function_transitions.create_and_add(run_state, _to_run)

	assert(jump_state != null )
	local_function_transitions.create_and_add(jump_state, _to_jump)

	assert(fall_state != null )
	local_function_transitions.create_and_add(fall_state, _to_fall)
	
	assert(character_body != null)
	assert(animation_player != null)
	assert(frontal != null)
	assert(superior != null)
	assert(motion_component != null)
	assert(motion_component.data != null)

	motion = motion_component.data


func _on_enter() -> void:
	#TODO: Criar animação de "pushing"
	#animation_player.play("pushing") 
	pass

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
		motion.base_speed,
		motion.acceleration * delta
	)

	MotionComponent.apply_gravity(
		character_body,
		motion.gravity * delta,
		motion.fall_speed
	)

	if(frontal.get_collider() is RigidBody3D):
		var collider: RigidBody3D = frontal.get_collider()
		
		collider.apply_force(direction * push_force, frontal.get_collision_normal())

	character_body.move_and_slide()



func _to_idle() -> DecisionResult:
	var input_direction: Vector3 = InputComponent.get_motion_input_direction()
	return DecisionResult.create(input_direction == Vector3.ZERO)

func _to_run() -> DecisionResult:
	var stop_colliding: bool = !frontal.is_colliding()
	return DecisionResult.create(stop_colliding)


func _to_jump() -> DecisionResult:
	assert(InputMap.has_action(InputActions.JUMP))
	var jump_button: bool = Input.is_action_just_pressed(InputActions.JUMP)
	return DecisionResult.create(jump_button)


func _to_fall() ->DecisionResult:
	var is_falling: bool = character_body.velocity.y < 0
	return DecisionResult.create(is_falling)
