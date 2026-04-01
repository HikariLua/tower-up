class_name InputComponent
extends Component


@export var data_template: InputData = InputData.new()
var data: InputData


static var default_direction_mode: InputData.DirectionMode = (
	InputData.DirectionMode.THREE_DIMENSIONS
)


func _enter_tree() -> void:
	assert(data_template != null)
	data = initialize_data(data_template)


static func get_motion_input_direction(
	mode: InputData.DirectionMode = default_direction_mode,
) -> Vector3:
	assert(InputMap.has_action(InputActions.MOVE_LEFT))
	assert(InputMap.has_action(InputActions.MOVE_RIGHT))

	var negative_x: StringName = InputActions.MOVE_LEFT
	var positive_x: StringName = InputActions.MOVE_RIGHT

	var vector: Vector3 = Vector3.ZERO
	vector.x = Input.get_axis(negative_x, positive_x)

	match mode:
		InputData.DirectionMode.TWO_DIMENSIONS:
			assert(InputMap.has_action(InputActions.MOVE_UP))
			assert(InputMap.has_action(InputActions.MOVE_DOWN))

			var negative_y: StringName = InputActions.MOVE_UP
			var positive_y: StringName = InputActions.MOVE_DOWN

			vector.y = Input.get_axis(negative_y, positive_y)

		InputData.DirectionMode.THREE_DIMENSIONS:
			assert(InputMap.has_action(InputActions.MOVE_BACKWARD))
			assert(InputMap.has_action(InputActions.MOVE_FORWARD))

			var negative_z: StringName = InputActions.MOVE_FORWARD
			var positive_z: StringName = InputActions.MOVE_BACKWARD

			vector.z = Input.get_axis(negative_z, positive_z)

	return vector


static func get_relative_motion_input_direction(
	camera_controller: Camera3DController,
	mode: InputData.DirectionMode = default_direction_mode,
) -> Vector3:
	var input_direction: Vector3 = get_motion_input_direction(mode).normalized()

	var relative_direction: Vector3 = camera_controller.transform.basis * input_direction

	match mode:
		InputData.DirectionMode.TWO_DIMENSIONS:
			relative_direction.z = 0

		InputData.DirectionMode.THREE_DIMENSIONS:
			relative_direction.y = 0

	return relative_direction.normalized()


static func get_motion_input_direction_with_bias(
	bias: Vector3,
	mode: InputData.DirectionMode = default_direction_mode,
) -> Vector3:
	assert(InputMap.has_action(InputActions.MOVE_LEFT))
	assert(InputMap.has_action(InputActions.MOVE_RIGHT))
	assert(bias != Vector3.ZERO)

	var negative_x: StringName = InputActions.MOVE_LEFT
	var positive_x: StringName = InputActions.MOVE_RIGHT

	var vector: Vector3 = Vector3.ZERO
	vector.x = _get_biased_axis(negative_x, positive_x, bias.x)

	match mode:
		InputData.DirectionMode.TWO_DIMENSIONS:
			assert(InputMap.has_action(InputActions.MOVE_UP))
			assert(InputMap.has_action(InputActions.MOVE_DOWN))

			var negative_y: StringName = InputActions.MOVE_UP
			var positive_y: StringName = InputActions.MOVE_DOWN

			vector.y = _get_biased_axis(negative_y, positive_y, bias.y)

		InputData.DirectionMode.THREE_DIMENSIONS:
			assert(InputMap.has_action(InputActions.MOVE_BACKWARD))
			assert(InputMap.has_action(InputActions.MOVE_FORWARD))

			var negative_z: StringName = InputActions.MOVE_FORWARD
			var positive_z: StringName = InputActions.MOVE_BACKWARD

			vector.z = _get_biased_axis(negative_z, positive_z, bias.z)

	return vector


static func get_camera_input_direction() -> Vector2:
	var vector: Vector2 = Input.get_vector(
		InputActions.CAMERA_LEFT,
		InputActions.CAMERA_RIGHT,
		InputActions.CAMERA_DOWN,
		InputActions.CAMERA_UP
	)

	return vector


static func _get_biased_axis(
	negative_action: StringName,
	positive_action: StringName,
	bias: float
) -> float:
	var negative_pressed: bool = Input.is_action_pressed(negative_action)
	var positive_pressed: bool = Input.is_action_pressed(positive_action)

	if negative_pressed and positive_pressed:
		return bias

	return Input.get_axis(negative_action, positive_action)
