class_name MotionComponent
extends Component


@export var data_template: MotionData = MotionData.new()
var data: MotionData


func _enter_tree() -> void:
	assert(data_template != null)
	data = initialize_data(data_template)


static func apply_gravity(gravity: float, character_body: CharacterBody3D, max_fall_speed: float = 0.0) -> void:
	assert(character_body != null)
	if character_body.is_on_floor():
		return

	if character_body.velocity.y <= -max_fall_speed and max_fall_speed != 0: 
		character_body.velocity.y -= gravity
		return

	character_body.velocity.y -= gravity


static func move_character_horizontaly(
	character_body: CharacterBody3D,
	direction: Vector3,
	target_speed: float,
	delta: float
) -> void:
	direction = direction.normalized()

	character_body.velocity.x = move_toward(
		character_body.velocity.x,
		target_speed * direction.x,
		delta
	)

	character_body.velocity.z = move_toward(
		character_body.velocity.z,
		target_speed * direction.z,
		delta
	)

static func character_is_pushing(character_body: CharacterBody3D, delta: float) -> bool:
	var collision: KinematicCollision3D  = character_body.move_and_collide(character_body.velocity * delta)
	
	if collision:
		return collision.get_collider() is RigidBody3D
	return false 

static func character_push_rigidbody(character_body: CharacterBody3D, delta: float, push_force: float) -> void: 
	var collision: KinematicCollision3D  = character_body.move_and_collide(character_body.velocity * delta)
	
	if collision:
		if collision.get_collider() is RigidBody3D:
			
			var collider: RigidBody3D = collision.get_collider()
			var push_direction : Vector3 = -collision.get_normal()
			
			collider.apply_impulse(push_direction * push_force) 
