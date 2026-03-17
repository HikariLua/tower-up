class_name UISystem
extends Node


var open_menus: Dictionary[StringName, Control] = {}

var _focused_controls: Dictionary[Control, Control] = {}
var _menu_stack: Array[Control] = []


func open_menu(packed_scene: PackedScene) -> void:
	if open_menus.has(packed_scene.resource_path):
		return

	var instance: Control = packed_scene.instantiate() as Control
	add_child.call_deferred(instance)

	_push_menu(packed_scene, instance)


func close_top_menu() -> void:
	_pop_top_menu()
	

func is_menu_open(packed_scene: PackedScene) -> bool:
	return open_menus.has(packed_scene.resource_path)


func focus_first_control(menu: Control) -> void:
	var first: Control = find_first_focusable(menu)
	if first:
		first.grab_focus.call_deferred()


func find_first_focusable(container: Control) -> Control:
	for child: Control in container.get_children():
		if child is Control and child.focus_mode != Control.FOCUS_NONE:
			return child
		var found: Control = find_first_focusable(child)
		if found:
			return found

	return null


func _push_menu(packed_scene: PackedScene, instance: Control) -> void:
	assert(not _menu_stack.has(instance))
	assert(not open_menus.has(packed_scene.resource_path))

	if not _menu_stack.is_empty():
		_disable_top_menu()

	_menu_stack.push_front(instance)
	open_menus[packed_scene.resource_path] = instance


func _pop_top_menu() -> void:
	assert(not _menu_stack.is_empty())
	assert(not open_menus.is_empty())

	var instance: Control = _menu_stack.pop_front()
	open_menus.erase(instance.scene_file_path)

	instance.queue_free()

	if not _menu_stack.is_empty():
		_enable_top_menu()


func _disable_top_menu() -> void:
	var menu: Control = _menu_stack[0]

	var focused: Control = get_viewport().gui_get_focus_owner()
	assert(focused != null)

	if menu.is_ancestor_of(focused):
		_focused_controls[menu] = focused
		
	menu.process_mode = Node.PROCESS_MODE_DISABLED
	menu.hide()


func _enable_top_menu() -> void:
	var menu: Control = _menu_stack[0]

	menu.process_mode = Node.PROCESS_MODE_INHERIT
	menu.show()

	if _focused_controls.has(menu):
		var last_focused: Control = _focused_controls[menu]

		if is_instance_valid(last_focused) and last_focused.can_process():
			last_focused.grab_focus.call_deferred()
		else:
			focus_first_control(menu)

		_focused_controls.erase(menu)
	else:
		focus_first_control(menu)
