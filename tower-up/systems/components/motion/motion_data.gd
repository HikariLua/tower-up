class_name MotionData
extends Resource

@export var max_speed: int = 100
@export var friction: int = 100
@export var acceleration: int = 100
@export var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var jump_impulse: float = 10
@export var max_fall_velocity: float = 52
@export var push_force: float = 0.5
