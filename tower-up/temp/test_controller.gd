extends Camera3DController


@export var state_machine: StateMachine
@export var free_camera: FreeRotationCameraState
@export var fixed_camera: FixedYRotationCameraState


func _ready() -> void:
	assert(state_machine != null)
	assert(free_camera != null)
	assert(fixed_camera != null)
#
	#state_machine.global_function_transitions.create_and_add(free_camera, _to_free)
	#state_machine.global_function_transitions.create_and_add(fixed_camera, _to_fixed)
#
#
#func _to_free() -> DecisionResult:
	#return DecisionResult.create(Input.is_action_pressed("ui_accept"))
#
#
#func _to_fixed() -> DecisionResult:
	#return DecisionResult.create(Input.is_action_pressed("ui_cancel"))
