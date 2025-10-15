extends ScriptGenerator

class_name ResultGenerator

class ResultTypeSettings:
	var typeName: String
	var valueType: String
	var filename: String
	var nullable: bool
	var testValues: Array
	
	func _init(p_typeName, p_valueType, p_filename, p_nullable, p_testValues):
		typeName = p_typeName
		valueType = p_valueType
		filename = p_filename
		nullable = p_nullable
		testValues = p_testValues
	
	func vars():
		return {
			"typeName": typeName,
			"valueType": valueType,
			"filename": filename,
			"nullable": nullable
		}

func get_source_data() -> Array:
	return [
		ResultTypeSettings.new("VoidResult", "", "void", true, []),
		ResultTypeSettings.new("Result", "Variant", "variant", true, ["1", "null"]),
		ResultTypeSettings.new("IntResult", "int", "int", false, ["1", "-1"]),
		ResultTypeSettings.new("BoolResult", "bool", "bool", false, ["true", "false"]),
		ResultTypeSettings.new("ArrayResult", "Array", "array", false, ["[]", "[1,2,3]"]),
		ResultTypeSettings.new("DictionaryResult", "Dictionary", "dictionary", false, ["{ \"hello\": \"world\" }"]),
		ResultTypeSettings.new("VariantArrayResult", "Array[Variant]", "variant_array", false, ["[null]", "[1]"]),
		ResultTypeSettings.new("DictionaryArrayResult", "Array[Dictionary]", "dictionary_array", false, ["[]", ["[{ \"hello\": \"world\" }]"]])
	]

func get_file_name(source_data: Variant) -> String:
	return source_data.filename + "_result"
	
func generate_source(source_data: Variant) -> String:
	var s = """extends ResultBase
class_name {typeName}"""

	if source_data.filename != "void":
		s += """
var _value: {valueType}
func value() -> {valueType}:
	return _value

## note: this will return false when OK but the value is null
func has_value():
	return is_ok()"""
		if source_data.nullable:
			s += " and _value != null"

	s += """
func _to_string() -> String:"""
	if source_data.filename != "void":
		s += """
	if is_ok() and _value != null:
		return str(_value)"""
	s += """
	return super._to_string()
	
static var _res_ok = {typeName}.new(_ok_msg)
static var _generic_err = {typeName}.new(_unknown_msg)

## Creates an error result. If a message is not given it defaults to "Unknown Error".
static func error(p_msg: StringName = _unknown_msg) -> {typeName}:
	if p_msg == _unknown_msg or p_msg.is_empty():
		return _generic_err
	return {typeName}.new(p_msg)
"""

	if source_data.filename == "void":
		s += """
## Creates an OK result with no error message and no value
static func ok() -> {typeName}:
	return _res_ok"""
	elif source_data.nullable:
		s += """
## Creates an OK result with no error message and {typeName} or null as the value
static func ok(p_value: {valueType} = null) -> {typeName}:
	if p_value == null:
		return _res_ok
	var r = {typeName}.new()
	r._value = p_value
	return r"""
	else:
		s += """
## Creates an OK result with no error message and {typeName} as the value
static func ok(p_value: {valueType}) -> {typeName}:
	var r = {typeName}.new()
	r._value = p_value
	return r"""
	s += """

## This converts a Godot Error to a {typeName}
static func err(p_err: Error) -> {typeName}:
	if p_err == OK:
		return _res_ok
	return {typeName}.error(_error_map[p_err])
"""
	return s.format(source_data.vars())
