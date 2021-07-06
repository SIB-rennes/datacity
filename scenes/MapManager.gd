extends Node2D

signal clicked_map(case_index, case_center_coords, occupied)


# References to the Road and Building tilemaps
onready var roads = $Roads
onready var buildings = $Buildings

# Value of the Occupied Tile
var occupied_val


func _ready():
	# Get the occupied tile once the tilemap was loaded
	occupied_val = buildings.tile_set.find_tile_by_name("Occupied")
	
	# Occupy cases where the player can not build
	occupy_large_buildings()
	occupy_roads()
	

##Use of unhandled to ignore events the GUI managed 
func _unhandled_input(event):
	if Input.is_action_just_released("MouseClic"):
			process_player_click(get_global_mouse_position())



func process_player_click(position):
	# Get the case on the building tilemap
	var case_index = buildings.world_to_map(position)
	var case_center = buildings.map_to_world(case_index)
	
	emit_signal("clicked_map", case_index, case_center, occupied(case_index))



func occupied(case_index):
	return buildings.get_cellv(case_index) != TileMap.INVALID_CELL



## Occupies the cases for the buildings larger than 1 case
func occupy_large_buildings():
	# Get the positions of the roads
	var building_positions = buildings.get_used_cells()
	
	# The "occupied" cell
	var occupied_val = buildings.tile_set.find_tile_by_name("Occupied")
	
	for pos in building_positions:
		# Get the building size
		var building_index = buildings.get_cellv(pos)
		var building_size = BuildingsData.get_size(building_index)
		
		# For each case of the building
		for x in range(pos.x, pos.x + building_size.x):
			for y in range(pos.y, pos.y + building_size.y):
				# If not the main case
				if x != pos.x or y != pos.y:
					# Set Occupied
					buildings.set_cell(x, y, occupied_val)



## Occupies the roads on the building layer
func occupy_roads():
	# Get the positions of the roads
	var road_positions = roads.get_used_cells()
	
	for pos in road_positions:
		buildings.set_cellv(pos, occupied_val)
