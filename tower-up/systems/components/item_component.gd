class_name ItemComponent
extends Node

@export var item: Area2D

const Y_POC: float = 144.0
const SCREEN_HEIGHT: float = 720.0
const TOTAL_SCREEN_HEIGHT: float = 768.0
const PRE_Y_POC_HEIGHT: float = 576.0

static var gravity: float = 200.0
static var max_fall_speed: float = 400.0
static var launch_impulse: float = -200.0
static var attraction_speed: float = 1200.0

var velocity: Vector2
var is_attracting: bool


func _ready() -> void:
	assert(item != null)
	velocity.y = launch_impulse


func apply_gravity(player: CharacterBody2D, delta: float) -> Vector2:
	if player and player.global_position.y <= ItemComponent.Y_POC and not is_attracting:
		is_attracting = true
	
	if is_attracting and player:
		var direction: Vector2 = (player.global_position - item.global_position).normalized()
		velocity = direction * attraction_speed
		return velocity
		
	velocity.y += gravity * delta
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed
	return velocity
