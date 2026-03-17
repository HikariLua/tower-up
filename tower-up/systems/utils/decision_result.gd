class_name DecisionResult
extends RefCounted


## TODO: add docs
var result: bool
## TODO: add docs
var message: Dictionary[Variant, Variant] = {}


# TODO: add docs
static func create(condition_result: bool) -> DecisionResult:
	var decision_result: DecisionResult = DecisionResult.new()

	decision_result.result = condition_result

	return decision_result


## TODO: add docs
# static func create_with_message(
# 	condition_result: bool,
# 	condition_message: Dictionary
# ) -> DecisionResult:
# 	var decision_result: DecisionResult = DecisionResult.new()
#
# 	decision_result.result = condition_result
# 	decision_result.message = condition_message
#
# 	return decision_result
