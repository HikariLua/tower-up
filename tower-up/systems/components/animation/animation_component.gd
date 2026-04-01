class_name AnimationComponent
extends Component


static var y_rotation_speed: float = 1440


static func rotate_horizontaly(
	node: Node3D,
	direction: Vector3,
	delta: float
) -> void:
	assert(node != null)

	if direction == Vector3.ZERO:
		return

	var forward_direction: Vector3 = -node.transform.basis.z
	forward_direction.y = 0.0
	forward_direction = forward_direction.normalized()

	var target_direction: Vector3 = direction
	target_direction.y = 0.0
	target_direction = target_direction.normalized()

	var angle: float = atan2(
		forward_direction.cross(target_direction).y,
		forward_direction.dot(target_direction)
	)

	if abs(angle) < 0.001:
		return

	var speed_rad: float = deg_to_rad(y_rotation_speed * delta)
	var rotate_amount: float = clamp(angle, -speed_rad, speed_rad)

	node.rotate_y(rotate_amount)
