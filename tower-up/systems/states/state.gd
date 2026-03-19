@abstract
class_name State
extends Node
## An abstract class for a finite state. Every state should be managed bt a StateMachine.


## Determine if the state can be get transitiond from other states.
@export var can_be_transitioned_to: bool = true

## Map of callable based transitions that will be checked each _physics_process frame.
## This transitions only get checked when the state is active.
var local_function_transitions: FunctionStateTransitionMap = FunctionStateTransitionMap.new()
## Map of signal based transitions that will transiton when the signal is emited.
## This transitions only recieves the signals when the state is active.
var local_signal_transitions: SignalStateTransitionMap = SignalStateTransitionMap.new()


## Called every time in the moment the state transitioned in.
## Animation player 
@export var animation_player: AnimationPlayer


## Called every time in the moment the state transitioned in.
func _on_enter() -> void:
	pass


## Called every time in the moment the state transitioned in if a message is passed from
## the previous state
func _on_enter_with_message(_message: Dictionary) -> void:
	pass


## State's finite Godot's _input equivalent
func _state_input(_event: InputEvent) -> void:
	pass


## State's finite Godot's _shortcut_input equivalent
func _state_shortcut_input(_event: InputEvent) -> void:
	pass


## State's finite Godot's _unhandled_input equivalent
func _state_unhandled_input(_event: InputEvent) -> void:
	pass


## State's finite Godot's _unhandled_key_input equivalent
func _state_unhandled_key_input(_event: InputEvent) -> void:
	pass


## State's finite Godot's _process equivalent
func _state_process(_delta: float) -> void:
	pass


## State's finite Godot's _physics_process equivalent
func _state_physics_process(_delta: float) -> void:
	pass


## Called every time in the moment the state gets transitioned out active.
func _on_exit() -> void:
	pass
