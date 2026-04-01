class_name MotionComponent
extends Component


static var dot_threshold: float = 0.7

@export var data_template: MotionData = MotionData.new()
var data: MotionData


func _enter_tree() -> void:
	assert(data_template != null)
	data = initialize_data(data_template)


static func apply_gravity(
	character_body: CharacterBody3D,
	gravity: float,
	max_fall_speed: float = 0.0
) -> void:
	assert(character_body != null)

	if character_body.is_on_floor():
		return

	character_body.velocity.y -= gravity

	if max_fall_speed == 0:
		return

	var fall_velocity: Vector3 = character_body.velocity
	fall_velocity.x = 0
	fall_velocity.z = 0

	var current_fall_speed: float = get_velocity_speed(fall_velocity)
	var is_falling: bool = fall_velocity.y < 0

	if current_fall_speed >= max_fall_speed and is_falling: 
		character_body.velocity.y = -max_fall_speed

	# if character_body.velocity.y > 0.75: 
	# 	character_body.velocity.y -= gravity / 2
	# elif character_body.velocity.y < 0: 
	# 	character_body.velocity.y -= gravity * 2.5



static func move_character_horizontaly(
	character_body: CharacterBody3D,
	direction: Vector3,
	target_speed: float,
	delta: float
) -> void:
	assert(character_body != null)

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


static func move_character_horizontaly_with_momentum(
	character_body: CharacterBody3D,
	direction: Vector3,
	base_max_speed: float,
	momentum: float,
	delta: float
) -> void:
	assert(character_body != null)
	assert(base_max_speed <= momentum)

	var current_horizontal_velocity: Vector3 = get_horizontal_velocity(
		character_body.velocity
	)

	var current_speed: float = get_velocity_speed(
		current_horizontal_velocity
	)

	var dot: float = current_horizontal_velocity.normalized().dot(direction)

	var target_speed: float = base_max_speed
	if dot > dot_threshold:
		target_speed = clampf(current_speed, base_max_speed, momentum)

	move_character_horizontaly(
		character_body,
		direction,
		target_speed,
		delta
	)


static func get_horizontal_velocity(
	velocity: Vector3,
	mode: InputData.DirectionMode = InputComponent.default_direction_mode,
) -> Vector3:
	var current_horizontal_velocity: Vector3 = velocity

	match mode:
		InputData.DirectionMode.TWO_DIMENSIONS:
			current_horizontal_velocity.z = 0

		InputData.DirectionMode.THREE_DIMENSIONS:
			current_horizontal_velocity.y = 0

	return current_horizontal_velocity


static func get_velocity_speed(velocity: Vector3) -> float:
	return velocity.length()


static func get_horizontal_speed(
	velocity: Vector3,
	mode: InputData.DirectionMode = InputComponent.default_direction_mode,
) -> float:
	var horizontal_velocity: Vector3 = get_horizontal_velocity(velocity, mode)

	return horizontal_velocity.length()


static func get_foward_direction(vector: Vector3) -> Vector3:
	vector.y = 0
	return vector.normalized()


static func get_right_direction(forward_direction: Vector3) -> Vector3:
	return forward_direction.cross(Vector3.UP).normalized()


static func get_lateral_speed(velocity: Vector3, right_direction: Vector3) -> float:
	return velocity.dot(right_direction)


static func steer_horizontal_movement(
	character_body: CharacterBody3D,
	direction: Vector3,
	target_steer_speed: float,
	delta: float,
	steer_struct: SteerStruct
) -> void:
	assert(character_body != null)

	var steering: float = direction.dot(steer_struct.right_direction)
	var target_lateral: float = steering * target_steer_speed
	
	steer_struct.lateral_speed = move_toward(steer_struct.lateral_speed, target_lateral, delta)
	steer_struct.lateral_speed = clampf(steer_struct.lateral_speed, -target_steer_speed, target_steer_speed)

	var new_horizontal_velocity: Vector3 = (
		(steer_struct.forward_direction * steer_struct.forward_speed) +
		(steer_struct.right_direction * steer_struct.lateral_speed)
	)

	character_body.velocity.x = new_horizontal_velocity.x
	character_body.velocity.z = new_horizontal_velocity.z


static func character_is_pushing(character_body: CharacterBody3D, delta: float) -> bool:
	# var collision: KinematicCollision3D  = character_body.move_and_collide(
	# 	character_body.velocity * delta
	# )
	# 
	# if collision:
	# 	return collision.get_collider() is RigidBody3D
	#
	print(character_body, delta)
	return false 


static func character_push_rigidbody(
	character_body: CharacterBody3D,
	delta: float,
	push_force: float
) -> void: 
	assert(character_body != null)

	var collision: KinematicCollision3D  = character_body.move_and_collide(
		character_body.velocity * delta
	)
	
	if collision:
		if collision.get_collider() is RigidBody3D:
			var collider: RigidBody3D = collision.get_collider()
			var push_direction : Vector3 = -collision.get_normal()
			
			collider.apply_impulse(push_direction * push_force) 
