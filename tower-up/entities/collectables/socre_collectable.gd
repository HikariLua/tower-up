extends Area3D


@export var score_value: int = 0
@export var sound_effect: AudioStreamPlayer

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	assert(body_entered.is_connected(_on_body_entered))
	assert(sound_effect)

func _on_body_entered(_body: Node3D) -> void:
	sound_effect.play()
	ScoreAutoload.increase_score(score_value) 



func _on_sound_finished() -> void:
	queue_free.call_deferred()
