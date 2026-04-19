extends Area3D


@export var score_value: int = 0


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	assert(body_entered.is_connected(_on_body_entered))


func _on_body_entered(_body: Node3D) -> void:
	ScoreAutoload.increase_score(score_value) 
	queue_free.call_deferred()
