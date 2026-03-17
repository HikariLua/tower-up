class_name HealthComponent
extends Node

######
#signal enemy_damage
#####

#signal damage_taken(amount: int)
signal health_points_depleted

# TEMPORÁRIO
@export var health_points: int = 1
@export var lives: int = 3


func take_damage(damage: int) -> void:
	health_points -= damage
	#enemy_damage.emit(damage)

	if health_points <= 0:
		health_points_depleted.emit()


static func enable_invicibility(hurtbox_collision: CollisionShape2D) -> void:
	assert(hurtbox_collision != null)
	_toggle_collision_disabled.call_deferred(hurtbox_collision, true)


static func disable_invicibility(hurtbox_collision: CollisionShape2D) -> void:
	assert(hurtbox_collision != null)
	_toggle_collision_disabled.call_deferred(hurtbox_collision, false)


static func _toggle_collision_disabled(collision: CollisionShape2D, value: bool) -> void:
	assert(collision != null)
	collision.disabled = value
