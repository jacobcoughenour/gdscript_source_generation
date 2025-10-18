extends SceneTree

func no_op() -> void:
	pass

func return_false() -> bool:
	return false
func return_false_untyped():
	return false
func return_false_variant() -> Variant:
	return false
func return_null_variant() -> Variant:
	return null
func return_optional_bool_empty() -> OptionalBool:
	return OptionalBool.empty()
func return_optional_bool_new() -> OptionalBool:
	return OptionalBool.new()
func return_optional_bool_with() -> OptionalBool:
	return OptionalBool.with(true)

func return_zero_vector2() -> Vector2:
	return Vector2(0, 0)
func return_empty_optional_vector2() -> OptionalVector2:
	return OptionalVector2.empty()

func return_empty_dictionary() -> Dictionary:
	return {}
func return_empty_optional_dictionary() -> OptionalDictionary:
	return OptionalDictionary.empty()

func return_empty_dictionary_array() -> Array[Dictionary]:
	return []
func return_empty_optional_dictionary_array() -> OptionalDictionaryArray:
	return OptionalDictionaryArray.empty()

func return_dictionary_array_with_3_items() -> Array[Dictionary]:
	return [
		{ "player_id": 1, "player_name": "tom" },
		{ "player_id": 2, "player_name": "joe" },
		{ "player_id": 3, "player_name": "mike" }
	]
func return_optional_dictionary_array_with_3_items() -> OptionalDictionaryArray:
	return OptionalDictionaryArray.with([
		{ "player_id": 1, "player_name": "tom" },
		{ "player_id": 2, "player_name": "joe" },
		{ "player_id": 3, "player_name": "mike" }
	])

func return_dictionary_array_with_20_items() -> Array[Dictionary]:
	return [
		{ "player_id": 1, "player_name": "tom" },
		{ "player_id": 2, "player_name": "joe" },
		{ "player_id": 3, "player_name": "mike" },
		{ "player_id": 4, "player_name": "tom" },
		{ "player_id": 5, "player_name": "joe" },
		{ "player_id": 6, "player_name": "mike" },
		{ "player_id": 7, "player_name": "tom" },
		{ "player_id": 8, "player_name": "joe" },
		{ "player_id": 9, "player_name": "mike" },
		{ "player_id": 10, "player_name": "tom" },
		{ "player_id": 11, "player_name": "joe" },
		{ "player_id": 12, "player_name": "mike" },
		{ "player_id": 13, "player_name": "tom" },
		{ "player_id": 14, "player_name": "joe" },
		{ "player_id": 15, "player_name": "mike" },
		{ "player_id": 16, "player_name": "tom" },
		{ "player_id": 17, "player_name": "joe" },
		{ "player_id": 18, "player_name": "mike" },
		{ "player_id": 19, "player_name": "mike" },
		{ "player_id": 20, "player_name": "mike" },
	]
func return_optional_dictionary_array_with_20_items() -> OptionalDictionaryArray:
	return OptionalDictionaryArray.with([
		{ "player_id": 1, "player_name": "tom" },
		{ "player_id": 2, "player_name": "joe" },
		{ "player_id": 3, "player_name": "mike" },
		{ "player_id": 4, "player_name": "tom" },
		{ "player_id": 5, "player_name": "joe" },
		{ "player_id": 6, "player_name": "mike" },
		{ "player_id": 7, "player_name": "tom" },
		{ "player_id": 8, "player_name": "joe" },
		{ "player_id": 9, "player_name": "mike" },
		{ "player_id": 10, "player_name": "tom" },
		{ "player_id": 11, "player_name": "joe" },
		{ "player_id": 12, "player_name": "mike" },
		{ "player_id": 13, "player_name": "tom" },
		{ "player_id": 14, "player_name": "joe" },
		{ "player_id": 15, "player_name": "mike" },
		{ "player_id": 16, "player_name": "tom" },
		{ "player_id": 17, "player_name": "joe" },
		{ "player_id": 18, "player_name": "mike" },
		{ "player_id": 19, "player_name": "mike" },
		{ "player_id": 20, "player_name": "mike" },
	])
	

const iterations = 1_000_000;

func _init() -> void:
	
	var cases = [
		"no_op",
		"",
		"return_false",
		"return_false_untyped",
		"return_false_variant",
		"return_null_variant",
		"return_optional_bool_empty",
		"return_optional_bool_new",
		"return_optional_bool_with",
		"",
		"return_zero_vector2",
		"return_empty_optional_vector2",
		"",
		"return_empty_dictionary",
		"return_empty_optional_dictionary",
		"",
		"return_empty_dictionary_array",
		"return_empty_optional_dictionary_array",
		"",
		"return_dictionary_array_with_3_items",
		"return_optional_dictionary_array_with_3_items",
		"",
		"return_dictionary_array_with_20_items",
		"return_optional_dictionary_array_with_20_items"
	];
	
	print("iterations: %d" % iterations)
	
	for case_name in cases:
		if case_name == "":
			print("")
			continue
		
		var callable = self.get(case_name)
		
		var memory = 0
		var time_max = 0
		var time_min = 2^63 - 1
		var time_sum = 0
		
		for i in iterations:
			var start_mem = OS.get_static_memory_usage()
			var start = Time.get_ticks_usec()
			
			# if i don't assign the return value to a variable then the memory usage reports 0
			@warning_ignore("unused_variable")
			var x = callable.call()
			
			var end = Time.get_ticks_usec()
			var end_mem = OS.get_static_memory_usage() - start_mem
			if i == 0:
				memory = end_mem
			var time = end - start
			
			time_max = max(time_max, time)
			time_min = min(time_min, time)
			time_sum = time_sum + time
			
		print(case_name)
		print("\tmemory=%d bytes  time{ max=%dµs min=%dµs avg=%fµs sum=%dµs }" % [memory, time_max, time_min, float(time_sum) / float(iterations), time_sum])

	self.quit(0)
