@tool
class_name PointBasedSpawner
extends Path3D


@export var node_scene: PackedScene: set = _set_node_scene

var _editor_preview: EditorPointBasedSpawner = null


func _ready() -> void:
	if Engine.is_editor_hint():
		_editor_preview = EditorPointBasedSpawner.new(self)
		_editor_preview.setup_editor_preview()
		_editor_preview.request_preview_update()
		return

	var parent: Node3D = get_parent() as Node3D
	assert(parent != null, "must have a valid parent")

	spawn_nodes.call_deferred(parent)
	self.queue_free.call_deferred()

	
func spawn_nodes(parent: Node3D) -> void:
	for point_index: int in range(curve.point_count):
		var node_instance: Node3D = node_scene.instantiate()

		var point_position: Vector3 = curve.get_point_position(point_index) 
		var new_position: Vector3 = self.global_position + point_position
		
		parent.add_child(node_instance)
		node_instance.global_position = new_position


func _set_node_scene(value: PackedScene) -> void:
	node_scene = value

	if _editor_preview == null:
		return

	_editor_preview.request_preview_update()
