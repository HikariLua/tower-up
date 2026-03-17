@abstract
class_name State
extends Node

## An abstract class for a finite state. Every state should be managed bt a StateMachine.


## TODO: add docs
@export var can_be_transitioned_to: bool = true

## TODO: add docs
var local_function_transitions: FunctionStateTransitionMap = FunctionStateTransitionMap.new()
var local_signal_transitions: SignalStateTransitionMap = SignalStateTransitionMap.new()


## TODO: add docs
func _on_enter() -> void:
	pass


## TODO: add docs
func _on_enter_with_message(_message: Dictionary) -> void:
	pass


## TODO: add docs
func _state_input(_event: InputEvent) -> void:
	pass


## TODO: add docs
func _state_shortcut_input(_event: InputEvent) -> void:
	pass


## TODO: add docs
func _state_unhandled_input(_event: InputEvent) -> void:
	pass


## TODO: add docs
func _state_unhandled_key_input(_event: InputEvent) -> void:
	pass


## TODO: add docs
func _state_process(_delta: float) -> void:
	pass


## TODO: add docs
func _state_physics_process(_delta: float) -> void:
	pass


## TODO: add docs
func _on_exit() -> void:
	pass
