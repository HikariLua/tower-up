class_name LeaderboardSystem
extends Node


var ranking: Array[LeaderboardEntry] = []
var current_entry: LeaderboardEntry = null


func add_new_entry(entry: LeaderboardEntry) -> void:
	if ranking.size() == 0:
		ranking.push_back(entry)
		return

	var insertion_index: int = _binary_search_descending(entry.score)
	ranking.insert(insertion_index, entry)


func _binary_search_descending(score: float) -> int:
	var low: int = 0
	var high: int = ranking.size()

	while low < high:
		var middle: int = ((low + high) / 2.0) as int
		if ranking[middle].score > score:
			low = middle + 1
		else:
			high = middle

	return low
