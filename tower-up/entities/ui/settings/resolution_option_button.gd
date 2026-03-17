extends OptionButton


func _ready() -> void:
	_populate_resolution_options()


func _populate_resolution_options() -> void:
	pass
# 	var screen_size: Vector2i = DisplayServer.screen_get_size()
#
# 	for resolution: Vector2i in SettingsSystem.COMMON_RESOLUTIONS:
# 		if resolution.x > screen_size.x or resolution.y > screen_size.y:
# 			continue
#
# 		resolution_options.add_item("%s x %s" % [resolution.x, resolution.y])
