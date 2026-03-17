class_name GameplayInfo
extends Node
## SINGLETON PARA INFORMAÇÕES RUNTIME DO JOGO

enum PowerLevel {
	LEVEL_01 = 25,
	LEVEL_02 = 50,
	LEVEL_03 = 75,
	LEVEL_04 = 100
}

const MAX_LIVES: int = 8
const MAX_BOMBS: int = 8
const MAX_GRAZE: int = 9999
const MAX_POWER_COUNT: int = 100

const MIN_SCORE: int = 0
const MIN_LIVES: int = 0
const MIN_BOMBS: int = 0
const MIN_GRAZE: int = 0
const MIN_POWER_COUNT: int = 0

var continues: int = 0

var score: int = MIN_SCORE: set = _set_score
var lives: int = MIN_LIVES: set = _set_lives
var bombs: int = MIN_BOMBS: set = _set_bombs
var graze: int = MIN_GRAZE: set = _set_graze

var power_count: int = MIN_POWER_COUNT: set = _set_power_count
var power_level: PowerLevel = PowerLevel.LEVEL_01


func _set_score(value: int) -> void:
	score = max(value, MIN_SCORE)


func _set_lives(value: int) -> void:
	lives = clampi(value, MIN_LIVES, MAX_LIVES)


func _set_bombs(value: int) -> void:
	bombs = clampi(value, MIN_BOMBS, MAX_BOMBS)


func _set_graze(value: int) -> void:
	graze = clampi(value, MIN_GRAZE, MAX_GRAZE)


func _set_power_count(value: int) -> void:
	power_count = clampi(value, MIN_POWER_COUNT, MAX_POWER_COUNT)
	print(power_count)
	_match_power_level()


func _match_power_level() -> void:
	if power_count <= PowerLevel.LEVEL_01:
		power_level = PowerLevel.LEVEL_01
	elif power_count <= PowerLevel.LEVEL_02:
		power_level = PowerLevel.LEVEL_02
	elif power_count <= PowerLevel.LEVEL_03:
		power_level = PowerLevel.LEVEL_03
	else:
		power_level = PowerLevel.LEVEL_04
