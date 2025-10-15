extends SceneTree

func _init():
	print("Running clean command")
	SourceGenerationPlugin._clean()
	quit(0)
