class_name MotionData
extends Resource

@export var base_speed: float = 10
@export var base_delta: float = 50

@export var ground_delta_multiplier: float = 1
@export var air_delta_multiplier: float = 0.7
@export var fall_speed_multiplier: float = 1.2

@export var jump_impulse: float = 10
@export var push_force: float = 0.5

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") * 2

var friction: float:
	get():
		return base_delta * ground_delta_multiplier

var air_resistence: float:
	get():
		return base_delta * air_delta_multiplier

var acceleration: float:
	get():
		return base_delta * ground_delta_multiplier

var air_acceleration: float:
	get():
		return base_delta * air_delta_multiplier

var fall_speed: float:
	get():
		return base_speed * fall_speed_multiplier

