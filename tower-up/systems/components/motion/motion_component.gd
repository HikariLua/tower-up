class_name MotionComponent
extends Component


@export var data_template: MotionData = MotionData.new()
var data: MotionData


func _enter_tree() -> void:
	assert(data_template != null)
	data = initialize_data(data_template)


static func apply_gravity(gravity: float, character_body: CharacterBody3D) -> float:
	assert(character_body != null)
	if character_body.is_on_floor():
		return 0.0

	return character_body.velocity.y - gravity


static func move_character_horizontaly(
	velocity: Vector3,
	direction: Vector3,
	target_speed: float,
	delta: float
) -> Vector3:
	var vector: Vector3 = velocity
	direction = direction.normalized()

	vector.x = move_toward(
		velocity.x,
		target_speed * direction.x,
		delta
	)

	vector.z = move_toward(
		velocity.z,
		target_speed * direction.z,
		delta
	)

	return vector
