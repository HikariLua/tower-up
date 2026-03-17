@abstract
class_name InputActions
extends RefCounted


const MOVE_LEFT: StringName = "move_left"
const MOVE_RIGHT: StringName = "move_right"
const MOVE_UP: StringName = "move_up"
const MOVE_DOWN: StringName = "move_down"
const MOVE_BACKWARD: StringName = "move_backward"
const MOVE_FORWARD: StringName = "move_forward"
const JUMP: StringName = "move_jump"

const MOVE_ACTIONS: Array[StringName] = [
	MOVE_LEFT,
	MOVE_RIGHT,
	MOVE_UP,
	MOVE_DOWN,
	MOVE_FORWARD,
	MOVE_BACKWARD
]

const CAMERA_LEFT: StringName = "camera_left"
const CAMERA_RIGHT: StringName = "camera_right"
const CAMERA_UP: StringName = "camera_up"
const CAMERA_DOWN: StringName = "camera_down"

const CAMERA_ACTIONS: Array[StringName] = [
	CAMERA_LEFT, 
	CAMERA_RIGHT,
	CAMERA_UP,
	CAMERA_DOWN 
]
