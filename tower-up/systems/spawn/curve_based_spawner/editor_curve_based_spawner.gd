class_name EditorCurveBasedSpawner
extends RefCounted


var _spawner: CurveBasedSpawner = null

var _preview_update_scheduled: bool = false
var _preview_container: Node3D = null


func _init(spawner: CurveBasedSpawner) -> void:
	_spawner = spawner


func setup_editor_preview() -> void:
	_preview_container = Node3D.new()
	var parent: Node3D = _spawner.get_parent()

	if parent == null:
		_spawner.add_child.call_deferred(_preview_container)
	else:
		parent.add_child.call_deferred(_preview_container)

	_preview_container.owner = null

	if _spawner.curve == null:
		printerr("%s curve is null" % _spawner.name)
		return

	if _spawner.curve.changed.is_connected(_on_curve_changed):
		return

	_spawner.curve.changed.connect(_on_curve_changed)


func request_preview_update() -> void:
	if not Engine.is_editor_hint():
		return

	if _preview_update_scheduled:
		return

	_preview_update_scheduled = true
	_update_editor_preview.call_deferred()


func cleanup() -> void:
	for child: Node in _preview_container.get_children():
		child.queue_free()

	if _spawner.curve and _spawner.curve.changed.is_connected(_on_curve_changed):
		_spawner.curve.changed.disconnect(_on_curve_changed)


func _update_editor_preview() -> void:
	_preview_update_scheduled = false

	if _preview_container == null:
		printerr("%s preview_container is null" % _spawner.name)
		return

	for child: Node in _preview_container.get_children():
		child.queue_free()

	if _spawner.node_scene == null or _spawner.spawn_count <= 0:
		return

	_spawner.path_follow.progress_ratio = 0
	_spawner.spawn_nodes.call_deferred(_preview_container)


func _on_curve_changed() -> void:
	request_preview_update()
