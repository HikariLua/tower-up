class_name FunctionStateTransitionMap
extends RefCounted
## A map of function state transitions.


## A dictionary with the target_state and the transition to it.
var transitions: Dictionary[State, FunctionStateTransition] = {}


## Adds a transition to the target_state in the map.
func add(target_state: State, transition: FunctionStateTransition) -> void:
	assert(target_state != null)
	assert(not transitions.has(target_state))

	transitions.get_or_add(target_state, transition)


## Creates a new transition to the target_state with the verification callabe and adds it to the map.
func create_and_add(
	target_state: State,
	callable: Callable,
	priority: int = 0
) -> void:
	assert(target_state != null)
	assert(not transitions.has(target_state))

	var transition: FunctionStateTransition = FunctionStateTransition.create(callable, priority) 

	transitions.get_or_add(target_state, transition)


## Switches an existent transition to a target_state with another.
func update(target_state: State, transition: FunctionStateTransition) -> void:
	assert(target_state != null)
	assert(transitions.has(target_state))

	transitions.set(target_state, transition)


## Enables or disables a transition to a target state.
func toggle_transition_disabled(target_state: State, disabled: bool) -> void:
	assert(target_state != null)
	assert(transitions.has(target_state))

	transitions[target_state].disabled = disabled


## Remove the transition to a target state.
func remove(target_state: State) -> void:
	assert(target_state != null)
	assert(transitions.has(target_state))

	transitions.erase(target_state)


## Checks if the map is empty.
func is_empty() -> bool:
	return transitions.is_empty()
