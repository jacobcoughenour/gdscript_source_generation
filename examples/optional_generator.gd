extends ScriptGenerator

class OptionalTypeSettings:
	var typeName: String
	var valueType: String
	var filename: String
	var defaultValue: String
	
	func _init(p_typeName, p_valueType, p_filename, p_defaultValue):
		typeName = p_typeName
		valueType = p_valueType
		filename = p_filename
		defaultValue = p_defaultValue
	
	func vars():
		return {
			"typeName": typeName,
			"valueType": valueType,
			"filename": filename,
			"defaultValue": defaultValue
		}

func get_source_data() -> Array:
	return [
		OptionalTypeSettings.new("OptionalInt", "int", "int", "0"),
		OptionalTypeSettings.new("OptionalBool", "bool", "bool", "false"),
		OptionalTypeSettings.new("OptionalString", "String", "string", "\"\""),
		OptionalTypeSettings.new("OptionalDictionary", "Dictionary", "dictionary", "{}"),
	]

func get_file_name(source_data: Variant) -> String:
	return "optional_" + source_data.filename
	
func generate_source(source_data: Variant) -> String:
	
	var s = """extends Object
class_name {typeName}

var _has_value: bool
var _value: {valueType}

func has_value() -> bool:
	return _has_value

func set_value(val: {valueType}) -> void:
	_has_value = true
	_value = val

func value() -> {valueType}:
	return _value

func get_or_default(default_value: {valueType}) -> {valueType}:
	if _has_value:
		return _value
	return default_value

func clear() -> void:
	_has_value = false
	_value = {defaultValue}

static func empty() -> {typeName}:
	return {typeName}.new()

static func with(val: {valueType}) -> {typeName}:
	var p = {typeName}.new()
	p.set_value(val)
	return p
"""
	return s.format(source_data.vars())
