class_name SignalStateTransition
extends RefCounted
## A signal based state transition.


## The dictionary with the signals and it's associated callables.
var connections: Dictionary[Signal, Callable] = {}


## Creates a new transition with a dictionary of all the connections that that should lead to a target_state.
static func create(state_connections: Dictionary[Signal, Callable]) -> SignalStateTransition:
	assert(not state_connections.is_empty())

	var transition: SignalStateTransition = SignalStateTransition.new()

	for connection: Signal in state_connections:
		assert(not connection.is_null())

		assert(state_connections[connection].is_valid())

		transition.connections.get_or_add(connection, state_connections[connection])

	return transition
	

## Adds a new connection to the connections dictionary.
func add_connection(signal_event: Signal, callable: Callable) -> void:
	assert(not connections.has(signal_event))
	connections.get_or_add(signal_event, callable)
