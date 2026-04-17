class_name FreeRotationCameraState
extends State

@export var camera_controller: Camera3DController


func _ready() -> void:
	assert(camera_controller != null)


func _state_input(event: InputEvent) -> void:
	if not event is InputEventMouseMotion:
		return

	var mouse_motion: InputEventMouseMotion = event as InputEventMouseMotion

	var direction: int = 1 if SettingsAutoload.invert_camera_axis else -1
	var sensitivity: float = SettingsAutoload.camera_mouse_sensitivity / 100.0

	var x_rotation: float = mouse_motion.relative.y * sensitivity * direction
	var y_rotation: float = mouse_motion.relative.x * sensitivity * direction

	camera_controller.rotation.x += deg_to_rad(x_rotation)
	camera_controller.rotation.y += deg_to_rad(y_rotation)
	print(sensitivity)


func _on_enter() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _state_physics_process(delta: float) -> void:
	var input_direction: Vector2 = InputComponent.get_camera_input_direction()

	if input_direction == Vector2.ZERO:
		return

	var direction: int = -1 if SettingsAutoload.invert_camera_axis else 1
	var sensitivity: int = SettingsAutoload.camera_sensitivity


	var y_rotation: float = input_direction.x * sensitivity * delta * direction
	var x_rotation: float = input_direction.y * sensitivity * delta * direction

	camera_controller.rotation.x += deg_to_rad(x_rotation)
	camera_controller.rotation.y += deg_to_rad(y_rotation)


func _on_exit() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
