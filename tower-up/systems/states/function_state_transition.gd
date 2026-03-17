class_name FunctionStateTransition
extends RefCounted


## TODO: add docs
var disabled: bool = false
## TODO: add docs
var priority: int = 0:
	set = change_priority

## TODO: add docs
var _condition_callable: Callable 


## TODO: add docs
static func create(callable: Callable, local_priority: int = 0) -> FunctionStateTransition:
	assert(callable.is_valid())
	assert(callable.get_argument_count() == 0)
	var transition: FunctionStateTransition = FunctionStateTransition.new()

	transition._condition_callable = callable
	transition.priority = local_priority

	return transition


## TODO: add docs
func check_transition() -> DecisionResult:
	if disabled:
		return DecisionResult.create(false)

	assert(_condition_callable.is_valid())
	var decision_result: DecisionResult = _condition_callable.call()
	
	return decision_result


func change_priority(new_priority: int) -> void:
	priority = new_priority
