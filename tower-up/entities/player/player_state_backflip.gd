class_name PlayerStateBackflip
extends State


@export_group(ExportGroups.ATRIBUTES)
@export var jump_impulse_multiplier: float = 1.2
@export var backflip_push_force: float = 2

@export_group(ExportGroups.BODIES)
@export var character_body: CharacterBody3D

@export_group(ExportGroups.COMPONENTS)
@export var motion_component: MotionComponent

@export_group(ExportGroups.STATES)
@export var idle_state: PlayerStateIdle

@export_group(ExportGroups.ANIMATION)
@export var animation_player: AnimationPlayer

var motion: MotionData


func _ready() -> void:
	assert(idle_state != null)
	local_function_transitions.create_and_add(idle_state, _to_idle)

	assert(character_body != null)
	assert(animation_player != null)
	assert(motion_component != null)
	assert(motion_component.data != null)

	motion = motion_component.data


func _on_enter() -> void:
	character_body.velocity.y = motion.jump_impulse * jump_impulse_multiplier

	var backward_direction: Vector3 = MotionComponent.get_foward_direction(
		character_body.transform.basis.z
	)

	character_body.velocity.x = backflip_push_force * backward_direction.x
	character_body.velocity.z = backflip_push_force * backward_direction.z

	animation_player.play("backflip")


func _state_physics_process(delta: float) -> void:
	assert(character_body != null)
	assert(motion != null)

	MotionComponent.apply_gravity(
		character_body,
		motion.gravity * delta,
		motion.fall_speed, 
	)

	character_body.move_and_slide()


func _to_idle() -> DecisionResult:
	var on_ground: bool = character_body.is_on_floor()
	return DecisionResult.create(on_ground)	
