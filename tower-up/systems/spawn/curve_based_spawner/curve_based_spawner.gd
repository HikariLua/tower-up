@tool
class_name CurveBasedSpawner
extends Path3D


@export var node_scene: PackedScene: set = _set_node_scene

@export_range(0, 99999) var spawn_count: int = 1: set = _set_spawn_count

var path_follow: PathFollow3D

var _editor_preview: EditorCurveBasedSpawner = null


func _ready() -> void:
	path_follow = PathFollow3D.new()
	path_follow.loop = false
	self.add_child(path_follow)

	if Engine.is_editor_hint():
		_editor_preview = EditorCurveBasedSpawner.new(self)
		_editor_preview.setup_editor_preview()
		_editor_preview.request_preview_update()
		return

	var parent: Node3D = get_parent() as Node3D
	assert(parent != null, "must have a valid parent")

	spawn_nodes.call_deferred(parent)
	self.queue_free.call_deferred()


func spawn_nodes(parent: Node3D) -> void:
	var follow_increment: float = curve.get_baked_length() / max(spawn_count - 1, 1)

	for count: int in range(spawn_count):
		var node_instance: Node3D = node_scene.instantiate() as Node3D

		parent.add_child(node_instance)
		node_instance.global_position = path_follow.global_position

		path_follow.progress += follow_increment


func _set_spawn_count(value: int) -> void:
	spawn_count = value

	if _editor_preview == null:
		return

	_editor_preview.request_preview_update()


func _set_node_scene(value: PackedScene) -> void:
	node_scene = value

	if _editor_preview == null:
		return

	_editor_preview.request_preview_update()


func _exit_tree() -> void:
	if _editor_preview == null:
		return

	_editor_preview.cleanup()
