extends ScriptGenerator

func get_source_data() -> Array:
	return ["1", "2"]

func get_file_name(source_data: Variant) -> String:
	return "example_" + source_data
