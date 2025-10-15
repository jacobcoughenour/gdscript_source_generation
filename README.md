# gdscript-codegen
An addon for Godot that adds basic scriptable source generation. Inspired by C# source generators.

All you have to do is extend ScriptGenerator and do the `Run Code Generation` command.

```gdscript
extends ScriptGenerator

func get_source_data() -> Array:
	return ["1", "2"]

func get_file_name(source_data: Variant) -> String:
	return "example_" + source_data
	
func generate_source(source_data: Variant) -> String:
	return """extends Object
class_name Example{name}

func test() -> String:
	return \"Hello from {name}\"
""".format({ "name": source_data })
```

This generator will generate the following files:

_generated_/example_1_gen.gd
```gdscript
extends Object
class_name Example1

func test() -> String:
	return "Hello from 1"
```

_generated_/example_2_gen.gd
```gdscript
extends Object
class_name Example2

func test() -> String:
	return "Hello from 2"
```

## FAQ

Why?

Read my post here for why I made this: 

Does this use AI?

No


Should I track the generated files in git/source control?

Yes. The files are not generated automatically when the project is built so it's going to be easier to just include all the files.