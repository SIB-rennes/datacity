extends TileMap

# Generates a string to save the buildings
func save_string():
	var res = []
	
	for coord in get_used_cells():
		var cell_value = get_cellv(coord)
		
		res.push_back(coord.x)
		res.push_back(coord.y)
		res.push_back(cell_value)
	
	return to_json(res)


func load_string(string: String):
	# Converts the string back to an array
	var array = Array(parse_json(string))
	
	# Check if the buildings have the correct values
	if array.size() % 3 != 0:
		print("Unvalid number of values in the map grid")
		return false
	
	# For each tile in the array
	for i in array.size()/3:
		var value = array.pop_back()
		var y = array.pop_back()
		var x = array.pop_back()
		
		set_cell(x, y, value)
	
	return true
