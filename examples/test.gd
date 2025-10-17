extends Node

func _ready():
	
	assert(Example1.new().test() == "Hello from 1")
	
	assert(not OptionalInt.empty().has_value())
	assert(OptionalInt.with(2).has_value())
	
	assert(not IntResult.error("hello").is_ok())
	assert(IntResult.ok(2).is_ok())
	
	assert(not DictionaryArrayResult.error("failed").is_ok())
	assert(DictionaryArrayResult.ok([{ "hello": "world" }]).is_ok())
	
	get_tree().quit(0)
