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
