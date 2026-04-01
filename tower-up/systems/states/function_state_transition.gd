class_name FunctionStateTransition
extends RefCounted
## A callable based state transition.


## Controls the activity of the transition. When true the callable always returns false.
var disabled: bool = false
## The priority of the transition, the higher the number higher the priority.
var priority: int = 0:
	set = change_priority

var _condition_callable: Callable 


## Creates a new transition using a callable to verify if the transitino should or not happen.
## The callable signature should not accept any arguments and should always
## return a DecisionResult
static func create(callable: Callable, local_priority: int = 0) -> FunctionStateTransition:
	assert(callable.is_valid())
	assert(callable.get_argument_count() == 0)
	var transition: FunctionStateTransition = FunctionStateTransition.new()

	transition._condition_callable = callable
	transition.priority = local_priority

	return transition


## Calls the callable associated with the transition to check if it should transition and returns it's DecisionResult.
func check_transition() -> DecisionResult:
	if disabled:
		return DecisionResult.create(false)

	assert(_condition_callable.is_valid())
	var decision_result: DecisionResult = _condition_callable.call()

	assert(decision_result is DecisionResult)
	
	return decision_result as DecisionResult


## Changes the transition's priority.
func change_priority(new_priority: int) -> void:
	priority = new_priority
