# GDScript Source Generation Addon for Godot

An addon for Godot that adds basic scriptable source generation. Inspired by [C# source generators](https://devblogs.microsoft.com/dotnet/introducing-c-source-generators/).

All you have to do is extend ScriptGenerator and Click `Run Source Generation` in Project -> Tools.

## Example
```gdscript
# minimal_generator.gd
extends ScriptGenerator

func get_source_data() -> Array:
	return ["1", "2"]

func get_file_name(source_data: Variant) -> String:
	return "example_" + source_data
	
func generate_source(source_data: Variant) -> String:
	return """extends RefCounted
class_name Example{name}

func test() -> String:
	return \"Hello from {name}\"
""".format({ "name": source_data })
```

This generator will generate the following files:

```gdscript
# _generated_/example_1_gen.gd
extends RefCounted
class_name Example1

func test() -> String:
	return "Hello from 1"
```

```gdscript
# _generated_/example_2_gen.gd
extends RefCounted
class_name Example2

func test() -> String:
	return "Hello from 2"
```

## Installation

> Requires Godot 4.5 or higher

* Copy `gdscript_source_generation` from the addons folder in this repo to your project's addons folder. 
* Open Project Settings -> Plugins then enable the plugin.

## FAQ

### Why?
Read my post for why I made this: [https://jacobcoughenour.com/posts/gdscript-fake-generics/](https://jacobcoughenour.com/posts/gdscript-fake-generics/)

### Does this use AI?
No.

### Can I generate the files outside of the editor?
Yes. Both the `generate` and `clean` commands are available as scripts. In the same directory that your project.godot file is in, you can run them like this:
```
godot --script addons/gdscript_source_generation/generate.gd
godot --script addons/gdscript_source_generation/clean.gd
```
> The `generate` script also cleans up the generated files so you don't have to always run `clean`

### Should I track the generated files in git/source control?

That is up to you. You can chose to ignore the `_generated_` folders but . To get around any automated build issues, add `godot --script addons/gdscript_source_generation/generate.gd` to your build script.

### Why make a `_generated_` folder?
This makes it easier for me to clean up all the generated files before generating new ones. I had it ending the files with `.gen.gd` but that broke gdUnit4 when I was generating unit tests.

### Can I change where the the generated files go?
Yes, If you override the `destination_directory_path()` method in your generator. It will still append `_generated_` to whatever path is returned.

### Is this maintained?
As long as I'm actually using it for my own projects.
