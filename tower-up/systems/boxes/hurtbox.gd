class_name Hurtbox
extends Area2D

@export_category(ExportGroups.NODES)
@export_group(ExportGroups.COMPONENTS)
@export var health: HealthComponent

func _ready() -> void:
	assert(health != null)
	area_entered.connect(_on_hurtbox_area_entered)
	assert(area_entered.is_connected(_on_hurtbox_area_entered))
	

func _on_hurtbox_area_entered(area: Area2D) -> void:
	assert(area is Hitbox, "invalid area of type %s" % typeof(area))
	
	var hitbox: Hitbox = area as Hitbox
	
	assert(health != null)
	
	health.take_damage(hitbox.damage)
