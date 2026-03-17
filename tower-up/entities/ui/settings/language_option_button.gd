extends OptionButton


var _language_locales: Array[StringName] = []


func _ready() -> void:
	item_selected.connect(_on_item_selected)
	assert(item_selected.is_connected(_on_item_selected))

	_populate_language_options()

	assert(_language_locales.has(SettingsAutoload.language))
	selected = _language_locales.find(SettingsAutoload.language)


func _populate_language_options() -> void:
	var supported_locales: PackedStringArray = TranslationServer.get_loaded_locales()

	if "pt_BR" in supported_locales:
		var txt: StringName = "%s (Português Brasileiro)" % tr(SettingsTRKeys.PORTUGUESE_BRAZIL)
		_add_language_locale(txt, "pt_BR")

	if "es_MX" in supported_locales:
		var txt: StringName = "%s (Español Latinoamericano)" % tr(SettingsTRKeys.SPANISH_LATIN_AMERICA)
		_add_language_locale(txt, "es_MX")

	if "ja_JP" in supported_locales:
		var txt: StringName = "%s (日本語)" % tr(SettingsTRKeys.JAPANESE)
		_add_language_locale(txt, "ja_JP")

	if "en_US" in supported_locales:
		var txt: StringName = "%s (English USA)" % tr(SettingsTRKeys.ENGLISH_US)
		_add_language_locale(txt, "en_US")

	
func _add_language_locale(item_text: StringName, locale_code: StringName) -> void:
	assert(not _language_locales.has(locale_code))

	add_item(item_text)
	_language_locales.append(locale_code)


func _on_item_selected(index: int) -> void:
	SettingsAutoload.language = _language_locales[index]
