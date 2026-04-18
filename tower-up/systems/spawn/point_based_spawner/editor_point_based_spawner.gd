class_name EditorPointBasedSpawner
extends RefCounted


var _spawner: PointBasedSpawner = null

var _preview_update_scheduled: bool = false
var _preview_container: Node3D = null


func _init(spawner: PointBasedSpawner) -> void:
	_spawner = spawner


func setup_editor_preview() -> void:
	_preview_container = Node3D.new()
	_preview_container.visible = _spawner.visible

	var parent: Node3D = _spawner.get_parent()

	if parent == null:
		_spawner.add_child.call_deferred(_preview_container)
	else:
		parent.add_child.call_deferred(_preview_container)

	_preview_container.owner = null

	_check_warning()

	if _spawner.curve == null:
		printerr("%s curve is null" % _spawner.name)
		return

	if _spawner.curve.changed.is_connected(_on_curve_changed):
		return

	_spawner.curve.changed.connect(_on_curve_changed)

	if _spawner.visibility_changed.is_connected(_on_spawner_visibility_changed):
		return

	_spawner.visibility_changed.connect(_on_spawner_visibility_changed)


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

	if _spawner.visibility_changed.is_connected(_on_spawner_visibility_changed):
		_spawner.visibility_changed.disconnect(_on_spawner_visibility_changed)


func _update_editor_preview() -> void:
	_preview_update_scheduled = false

	if _preview_container == null:
		printerr("%s preview_container is null" % _spawner.name)
		return

	for child: Node in _preview_container.get_children():
		child.queue_free()

	if _spawner.node_scene == null:
		return

	_spawner.spawn_nodes.call_deferred(_preview_container)

	_check_warning()


func _check_warning() -> void:
	if not _spawner.is_ancestor_of(_preview_container):
		return

	if _spawner.scale != Vector3(1, 1, 1):
		push_warning(
			"%s spawner scale is different than 1. preview might be misleading" %
			_spawner.name
		)

	if _spawner.rotation != Vector3(0, 0, 0):
		push_warning(
			"%s spawner rotation is different than 0. preview might be misleading" %
			_spawner.name
		)


func _on_curve_changed() -> void:
	request_preview_update()


func _on_spawner_visibility_changed() -> void:
	_preview_container.visible = _spawner.visible
