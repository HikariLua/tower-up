class_name StateMachine
extends Node
## Generic finite state machine.
## Works by limiting scripts to work one at a time.


## Emited when transition_state executes.
signal active_state_changed(old_state: State, new_state: State)
## Emited when state_machine gets enabled or disabled.
signal activity_changed(disabled: bool)
## Emited when a specific state gets enabled or disabled.
signal state_transition_allowed_changed(state: State, enabled: bool)

@export_group(ExportGroups.STATES)
## State that will run when the scene is ready.
@export var initial_state: State

@export_group(ExportGroups.ATRIBUTES)
## state_history maximun size. When set to 0 no history will be added.
@export_range(0, 10, 1, "or_greater") var max_state_history_size: int = 0

## Current state being executed.
var active_state: State

## History of states executed. If max_state_history_size is 0 the array will be empty.
var state_history: Array[State] = []

## A map with the global transiions activated by signal.
var global_signal_transitions: SignalStateTransitionMap = SignalStateTransitionMap.new()
## A map with the global transiions activated by callables.
var global_function_transitions: FunctionStateTransitionMap = FunctionStateTransitionMap.new()

var _disabled: bool = false:
	set = _set_disabled


func _ready() -> void:
	assert(initial_state != null)
	assert(self.is_ancestor_of(initial_state))

	active_state = initial_state
	active_state._on_enter()


func _input(event: InputEvent) -> void:
	if _disabled:
		return

	assert(active_state != null)
	active_state._state_input(event)


func _shortcut_input(event: InputEvent) -> void:
	if _disabled:
		return

	assert(active_state != null)
	active_state._state_shortcut_input(event)


func _unhandled_input(event: InputEvent) -> void:
	if _disabled:
		return

	assert(active_state != null)
	active_state._state_unhandled_input(event)


func _unhandled_key_input(event: InputEvent) -> void:
	if _disabled:
		return

	assert(active_state != null)
	active_state._state_unhandled_key_input(event)


func _process(delta: float) -> void:
	if _disabled: 
		return

	assert(active_state != null)
	active_state._state_process(delta)


func _physics_process(delta: float) -> void:
	if _disabled: 
		return

	assert(active_state != null)
	active_state._state_physics_process(delta)

	var has_transitioned: bool = _check_global_function_transitions()

	if has_transitioned:
		return

	_check_state_function_transitions()


## Transitions to target state. You can optionaly pass a message to the target_state.
## In case a message is passed the state will execute _on_enter_with_message instead
## of the regular _on_enter.
func transition_state(target_state: State, message: Dictionary = {}) -> void:
	if _disabled:
		return

	if not target_state.can_be_transitioned_to:
		return

	assert(active_state != null)
	assert(target_state != null)
	assert(
		self.is_ancestor_of(target_state),
		"%s is not a child of the state machine" % target_state
	)
	
	var old_state: State = active_state
	var new_state: State = target_state
	
	active_state.local_signal_transitions.disconnect_all()
	active_state._on_exit()

	active_state = target_state

	_update_state_history(target_state)

	if message.is_empty():
		active_state._on_enter()
	else:
		active_state._on_enter_with_message(message)

	active_state.local_signal_transitions.connect_all()
	
	active_state_changed.emit(old_state, new_state)


## Disables a target_state, preventing any other state to transition to it.
func disable_state(target_state: State) -> void:
	assert(self.is_ancestor_of(target_state))
	target_state.can_be_transitioned_to = false
	state_transition_allowed_changed.emit(target_state, target_state.can_be_transitioned_to)


## Enables a target_state, allowing any other state to transition to it.
func enable_state(target_state: State) -> void:
	assert(self.is_ancestor_of(target_state))
	target_state.can_be_transitioned_to = true
	state_transition_allowed_changed.emit(target_state, target_state.can_be_transitioned_to)


## Enables or disables the state machine.
func toggle_disabled(disabled: bool) -> void:
	_set_disabled.call_deferred(disabled)


## Check if state machine is disabled.
func is_disabled() -> bool:
	return _disabled


func _check_global_function_transitions() -> bool:
	if global_function_transitions.is_empty():
		return false

	var has_transitioned: bool = _check_function_transitions(global_function_transitions)
	return has_transitioned


func _check_state_function_transitions() -> bool:
	assert(active_state != null)
	if active_state.local_function_transitions.is_empty():
		return false

	var has_transitioned: bool = _check_function_transitions(
		active_state.local_function_transitions
	)

	return has_transitioned


func _check_function_transitions(transitions_map: FunctionStateTransitionMap) -> bool:
	if _disabled:
		return false

	var transitions_dict: Dictionary[State, FunctionStateTransition] = transitions_map.transitions
	
	var priority_state: State = null
	var priority_state_message: Dictionary = {}
	var priority_state_priority: int = 0

	for target_state: State in transitions_dict.keys():
		assert(target_state != null)
		if not target_state.can_be_transitioned_to:
			continue

		var transition: FunctionStateTransition = transitions_dict.get(target_state)

		if transition.disabled:
			continue

		var decision_result: DecisionResult = transition.check_transition()

		if decision_result.result == true:
			if transition.priority > priority_state_priority or priority_state == null:
				priority_state = target_state
				priority_state_priority = transition.priority
				priority_state_message = decision_result.message

	if priority_state == null:
		return false

	transition_state(priority_state, priority_state_message)
	return true


func _update_state_history(state: State) -> void:
	if max_state_history_size == 0:
		return

	assert(state_history.size() <= max_state_history_size)

	if state_history.size() == max_state_history_size:
		state_history.pop_back()
	
	state_history.push_front(state)


func _set_disabled(value: bool) -> void:
	_disabled = value
	activity_changed.emit(_disabled)
