extends SceneTree

func _init():
	print("Running generate command")
	SourceGenerationPlugin._clean()
	SourceGenerationPlugin._codegen()
	quit(0)
