extends TileMap

var tile
var building_size
var validation = false
var can_place = false
# Generates a string to save the buildings
func _ready():
	tile_set.tile_set_modulate(48, Color("00ffffff"))

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

func set_preview_offset(building_to_place):
	$preview/preview_tile/building.offset = BuildingsData.OFFSET[building_to_place]
	$preview/preview_tile_2/building.offset = BuildingsData.OFFSET[building_to_place]
	$preview/preview_tile_3/building.offset = BuildingsData.OFFSET[building_to_place]

func _physics_process(delta):
	if validation == false:
		var mouse_pos = get_global_mouse_position()
		tile = world_to_map(mouse_pos)
		$preview.position = map_to_world(tile)
		if can_place == true:
			$preview/preview_tile.modulate  = Color(0, 1, 0)
			$preview/preview_tile_2/building.modulate = Color(0, 1, 0)
		else:
			$preview/preview_tile.modulate = Color(1, 0, 0 )
			$preview/preview_tile_2/building.modulate = Color(1, 0, 0)
					
					
func show_constructible_tile(value):
	if value == true:
		tile_set.tile_set_modulate(48, Color("ffffff"))
	else:
		tile_set.tile_set_modulate(48, Color("00ffffff"))
