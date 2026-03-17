class_name FunctionStateTransitionMap
extends RefCounted

var transitions: Dictionary[State, FunctionStateTransition] = {}


## TODO: add docs
func add(target_state: State, transition: FunctionStateTransition) -> void:
	assert(target_state != null)
	assert(not transitions.has(target_state))

	transitions.get_or_add(target_state, transition)


## TODO: add docs
func create_and_add(
	target_state: State,
	callable: Callable,
	priority: int = 0
) -> void:
	assert(target_state != null)
	assert(not transitions.has(target_state))

	var transition: FunctionStateTransition = FunctionStateTransition.create(callable, priority) 

	transitions.get_or_add(target_state, transition)


## TODO: add docs
func update(target_state: State, transition: FunctionStateTransition) -> void:
	assert(target_state != null)
	assert(transitions.has(target_state))

	transitions.set(target_state, transition)


## TODO: add docs
func toggle_transition_disabled(target_state: State, disabled: bool) -> void:
	assert(target_state != null)
	assert(transitions.has(target_state))

	transitions[target_state].disabled = disabled


## TODO: add docs
func remove(target_state: State) -> void:
	assert(target_state != null)
	assert(transitions.has(target_state))

	transitions.erase(target_state)


func is_empty() -> bool:
	return transitions.is_empty()
