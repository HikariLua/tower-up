extends Area3D


@export var score_value: int = 0
@export var sound_effect: AudioStreamPlayer

var hasCollected: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	assert(body_entered.is_connected(_on_body_entered))
	assert(sound_effect)

func _on_body_entered(_body: Node3D) -> void:
	if hasCollected: return 
	
	hasCollected = true
	ScoreAutoload.increase_score(score_value) 
	$CollisionShape3D.set_deferred("disabled", true)
	visible=false
	sound_effect.play()
	
	sound_effect.finished.connect(queue_free.call_deferred)
