class_name SettingsSystem
extends Node


enum GraphicQualityPreset {
	VERY_LOW,
	LOW,
	MEDIUM,
	HIGH,
	ULTRA,
	CUSTOM
}

const COMMON_RESOLUTIONS: Array[Vector2i] = [
	Vector2i(3840, 2160), # 4K UHD
	Vector2i(2560, 1440), # 2K QHD
	Vector2i(1920, 1080), # Full HD
	Vector2i(1600, 900),
	Vector2i(1366, 768),
	Vector2i(1280, 720),  # HD
	Vector2i(1152, 648),
	Vector2i(1024, 576),
	Vector2i(960, 540),
	Vector2i(854, 480),
	Vector2i(800, 600)
]

const SETTINGS_PATH: StringName = "user://settings.cfg"

const AUDIO_SECTION: StringName = "AUDIO"
const CAMERA_SECTION: StringName = "CAMERA"
const VIDEO_SECTION: StringName = "VIDEO"
const LOCALE_SECTION: StringName = "LOCALE"
const CONTROLS_SECTION: StringName = "CONTROLS"

const MASTER_VOLUME_KEY: StringName = "master_volume"
const MUSIC_VOLUME_KEY: StringName = "music_volume"
const SFX_VOLUME_KEY: StringName = "sfx_volume"

const CAMERA_SENSITIVITY_KEY: StringName = "camera_sensitivity"
const MOUSE_SENSITIVITY_KEY: StringName = "mouse_sensitivity"
const INVERT_CAMERA_AXIS_KEY: StringName = "invert_camera_axis"

const RESOLUTION_WIDTH_KEY: StringName = "resolution_width"
const RESOLUTION_HEIGHT_KEY: StringName = "resolution_height"
const WINDOW_MODE_KEY: StringName = "window_mode"
const QUALITY_PRESET_KEY: StringName = "quality_preset"
const LANGUAGE_KEY: StringName = "language"

var master_volume: int: set = _set_master_volume
var music_volume: int: set = _set_music_volume
var sfx_volume: int: set = _set_sfx_volume
var camera_sensitivity: int: set = _set_camera_sensitivity
var camera_mouse_sensitivity: int: set = _set_camera_mouse_sensitivity
var invert_camera_axis: bool: set = _set_invert_camera_axis
var screen_resolution: Vector2i: set = _set_screen_resolution
var window_mode: DisplayServer.WindowMode: set = _set_window_mode
var graphic_quality_preset: GraphicQualityPreset: set = _set_graphic_quality_preset
var language: StringName: set = _set_language

var _config: ConfigFile = ConfigFile.new()
var _settings_loaded: bool = false


func _ready() -> void:
	_load_settings()


func save_settings() -> void:
	_config.set_value(AUDIO_SECTION, MASTER_VOLUME_KEY, master_volume)
	_config.set_value(AUDIO_SECTION, MUSIC_VOLUME_KEY, music_volume)
	_config.set_value(AUDIO_SECTION, SFX_VOLUME_KEY, sfx_volume)

	_config.set_value(CAMERA_SECTION, CAMERA_SENSITIVITY_KEY, camera_sensitivity)
	_config.set_value(CAMERA_SECTION, MOUSE_SENSITIVITY_KEY, camera_mouse_sensitivity)
	_config.set_value(CAMERA_SECTION, INVERT_CAMERA_AXIS_KEY, invert_camera_axis)

	_config.set_value(VIDEO_SECTION, RESOLUTION_WIDTH_KEY, screen_resolution.x)
	_config.set_value(VIDEO_SECTION, RESOLUTION_HEIGHT_KEY, screen_resolution.y)
	_config.set_value(VIDEO_SECTION, WINDOW_MODE_KEY, window_mode)
	_config.set_value(VIDEO_SECTION, QUALITY_PRESET_KEY, graphic_quality_preset)

	_config.set_value(LOCALE_SECTION, LANGUAGE_KEY, language)

	var error: Error = _config.save(SETTINGS_PATH)
	if error != OK:
		printerr("error saving config file: %s" % error_string(error))
		OS.alert(tr(SettingsTRKeys.ERROR_SAVE_CONFIG) % error_string(error))



func load_settings() -> void:
	_load_settings()


func apply_all_settings() -> void:
	_apply_audio_settings()
	_apply_video_settings()
	_apply_locale_settings()


func set_defaults() -> void:
	master_volume = _get_default_master_volume()
	music_volume = _get_default_music_volume()
	sfx_volume = _get_default_sfx_volume()
	camera_sensitivity = _get_default_camera_sensitivity()
	camera_mouse_sensitivity = _get_default_camera_mouse_sensitivity()
	invert_camera_axis = _get_default_invert_camera_axis()
	screen_resolution = _get_default_resolution()
	window_mode = _get_default_window_mode()
	graphic_quality_preset = _get_default_quality_preset()
	language = _get_default_language()


func _load_settings() -> void:
	var error: Error = _config.load(SETTINGS_PATH)

	if error == ERR_FILE_NOT_FOUND:
		set_defaults()
		save_settings()
		return

	if error != OK:
		printerr("error loading config file: %s" % error_string(error))
		OS.alert(tr(SettingsTRKeys.ERROR_LOAD_CONFIG) % error_string(error))

	master_volume = _config.get_value(AUDIO_SECTION, MASTER_VOLUME_KEY, _get_default_master_volume())
	music_volume = _config.get_value(AUDIO_SECTION, MUSIC_VOLUME_KEY, _get_default_music_volume())
	sfx_volume = _config.get_value(AUDIO_SECTION, SFX_VOLUME_KEY, _get_default_sfx_volume())

	camera_sensitivity = _config.get_value(
		CAMERA_SECTION, CAMERA_SENSITIVITY_KEY, _get_default_camera_sensitivity()
	)
	camera_mouse_sensitivity = _config.get_value(
		CAMERA_SECTION, MOUSE_SENSITIVITY_KEY, _get_default_camera_mouse_sensitivity()
	)
	invert_camera_axis = _config.get_value(
		CAMERA_SECTION, INVERT_CAMERA_AXIS_KEY, _get_default_invert_camera_axis()
	)

	var res_x: int = _config.get_value(VIDEO_SECTION, RESOLUTION_WIDTH_KEY, _get_default_resolution().x)
	var res_y: int = _config.get_value(VIDEO_SECTION, RESOLUTION_HEIGHT_KEY, _get_default_resolution().y)
	screen_resolution = Vector2i(res_x, res_y)

	window_mode = _config.get_value(VIDEO_SECTION, WINDOW_MODE_KEY, _get_default_window_mode())
	graphic_quality_preset = _config.get_value(VIDEO_SECTION, QUALITY_PRESET_KEY, _get_default_quality_preset())
	language = _config.get_value(LOCALE_SECTION, LANGUAGE_KEY, _get_default_language())

	_settings_loaded = true

	apply_all_settings()


func _get_default_master_volume() -> int:
	return 80


func _get_default_music_volume() -> int:
	return 100


func _get_default_sfx_volume() -> int:
	return 100


func _get_default_camera_sensitivity() -> int:
	return 50


func _get_default_camera_mouse_sensitivity() -> int:
	return 50


func _get_default_invert_camera_axis() -> bool:
	return false


func _get_default_resolution() -> Vector2i:
	var width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
	var height: int = ProjectSettings.get_setting("display/window/size/viewport_height")
	return Vector2i(width, height)


func _get_default_window_mode() -> DisplayServer.WindowMode:
	var mode: int = ProjectSettings.get_setting("display/window/size/mode")
	return mode as DisplayServer.WindowMode


func _get_default_quality_preset() -> GraphicQualityPreset:
	return GraphicQualityPreset.MEDIUM


func _get_default_language() -> StringName:
	var locale: StringName = OS.get_locale()

	locale = _get_closest_locale(locale)

	return locale


func _get_closest_locale(locale: StringName) -> StringName:
	locale = TranslationServer.standardize_locale(locale)

	if locale in TranslationServer.get_loaded_locales():
		return locale

	if locale.begins_with("pt"):
		return "pt_BR"
	elif locale.begins_with("es"):
		return "es_MX"
	elif locale.begins_with("en"):
		return "en_US"

	return "en_US"
		

func _apply_audio_settings() -> void:
	var master_bus: int = AudioServer.get_bus_index(AudioBuses.MASTER)
	var music_bus: int = AudioServer.get_bus_index(AudioBuses.MUSIC)
	var sfx_bus: int = AudioServer.get_bus_index(AudioBuses.SFX)

	assert(master_bus >= 0, "Master audio bus not found")
	assert(music_bus >= 0, "Music audio bus not found")
	assert(sfx_bus >= 0, "SFX audio bus not found")

	AudioServer.set_bus_volume_db(master_bus, linear_to_db(master_volume / 100.0))
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(music_volume / 100.0))
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(sfx_volume / 100.0))


func _apply_video_settings() -> void:
	DisplayServer.window_set_size(screen_resolution)
	DisplayServer.window_set_mode(window_mode)


func _apply_locale_settings() -> void:
	TranslationServer.set_locale(language)


func _set_master_volume(value: int) -> void:
	assert(value >= 0 and value <= 100, "Master volume must be between 0 and 100")
	if master_volume == value:
		return

	master_volume = clampi(value, 0, 100)
	if _settings_loaded:
		_apply_audio_settings()


func _set_music_volume(value: int) -> void:
	assert(value >= 0 and value <= 100, "Music volume must be between 0 and 100")
	if music_volume == value:
		return

	music_volume = clampi(value, 0, 100)
	if _settings_loaded:
		_apply_audio_settings()


func _set_sfx_volume(value: int) -> void:
	assert(value >= 0 and value <= 100, "SFX volume must be between 0 and 100")
	if sfx_volume == value:
		return

	sfx_volume = clampi(value, 0, 100)
	if _settings_loaded:
		_apply_audio_settings()


func _set_camera_sensitivity(value: int) -> void:
	assert(value >= 0 and value <= 100, "Camera sensitivity must be between 0 and 100")
	if camera_sensitivity == value:
		return

	camera_sensitivity = clampi(value, 0, 100)


func _set_camera_mouse_sensitivity(value: int) -> void:
	assert(value >= 0 and value <= 100, "Camera mouse sensitivity must be between 0 and 100")
	if camera_mouse_sensitivity == value:
		return

	camera_mouse_sensitivity = clampi(value, 0, 100)


func _set_invert_camera_axis(value: bool) -> void:
	if invert_camera_axis == value:
		return

	invert_camera_axis = value


func _set_screen_resolution(value: Vector2i) -> void:
	assert(value.x > 0 and value.y > 0, "Resolution dimensions must be positive")
	if screen_resolution == value:
		return

	screen_resolution = abs(value)
	if _settings_loaded:
		_apply_video_settings()


func _set_window_mode(value: DisplayServer.WindowMode) -> void:
	if window_mode == value:
		return

	window_mode = clampi(value as int, 0, 4) as DisplayServer.WindowMode
	if _settings_loaded:
		_apply_video_settings()


func _set_graphic_quality_preset(value: GraphicQualityPreset) -> void:
	if graphic_quality_preset == value:
		return

	graphic_quality_preset = value
	if _settings_loaded:
		pass


func _set_language(value: String) -> void:
	assert(not value.is_empty(), "Language cannot be empty")
	#assert(value in TranslationServer.get_loaded_locales())

	if language == value:
		return

	if not value in TranslationServer.get_loaded_locales():
		value = _get_closest_locale(value)

	language = value
	if _settings_loaded:
		_apply_locale_settings()
