class_name FixedYRotationCameraState
extends State


const FIXED_ROTATION_ANIMATION: StringName = "fixed_rotation"

@export var input_disabled: bool = false
@export var rotation_degrees_step: float = 90

@export var camera_controller: Camera3DController = get_parent()
@export var animation_player: AnimationPlayer


func _ready() -> void:
	assert(camera_controller != null)
	assert(animation_player != null)


func _state_physics_process(_delta: float) -> void:
	if input_disabled:
		return

	assert(InputMap.has_action(InputActions.CAMERA_LEFT))
	assert(InputMap.has_action(InputActions.CAMERA_RIGHT))

	if Input.is_action_just_pressed(InputActions.CAMERA_LEFT):
		_rotate_camera_y(-rotation_degrees_step)
	if Input.is_action_just_pressed(InputActions.CAMERA_RIGHT):
		_rotate_camera_y(rotation_degrees_step)


func _rotate_camera_y(degrees: float) -> void:
	assert(camera_controller != null)

	var end_value: Vector3 = Vector3(
		camera_controller.rotation.x,
		camera_controller.rotation.y + deg_to_rad(degrees),
		camera_controller.rotation.z
	)

	_update_rotation_animation(camera_controller.rotation, end_value)

	animation_player.play(FIXED_ROTATION_ANIMATION)


func _update_rotation_animation(start_value: Vector3, end_value: Vector3) -> void:
	if animation_player.is_playing():
		return

	assert(animation_player != null)
	assert(animation_player.has_animation(FIXED_ROTATION_ANIMATION))

	var animation: Animation = animation_player.get_animation(FIXED_ROTATION_ANIMATION)

	var track_index: int = 0
	var start_key_index: int = 0
	var end_key_index: int = 1

	animation.track_set_key_value(track_index, start_key_index, start_value)
	animation.track_set_key_value(track_index, end_key_index, end_value)
