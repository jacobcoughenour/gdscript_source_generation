@abstract
extends Object
class_name ScriptGenerator

## return a list of variants where each one corresponds to a file that will be
## created.
func get_source_data() -> Array:
	return []
	
## return a path to the directory the file should be written to.
## returning null will default to the same directory the generator script is in.
func destination_directory_path(source_data: Variant) -> Variant:
	return null

## given source data from get_source_data(), return the name of the file
func get_file_name(source_data: Variant) -> String:
	return ""
	
## given source data from get_source_data(), return the file contents
func generate_source(source_data: Variant) -> String:
	return ""
