class_name ScoreSystem
extends Node


var _score: int = 0:
	set = _set_score,
	get = get_score


func increase_score(amount: int) -> void:
	_score += amount


func decrease_score(amount: int) -> void:
	_score -= amount


func get_score() -> int:
	return _score


func _set_score(value: int) -> void:
	_score = max(0, value)
	print("score: ", _score)
