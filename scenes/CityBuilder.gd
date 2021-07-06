extends Node2D

# the buildings Tilemap
onready var buildings_map = $Map/Buildings

# Value of the Occupied Tile
var occupied_tile

var building_to_place = 4


func _ready():
	occupied_tile = buildings_map.tile_set.find_tile_by_name("Occupied")



## Called from the Map signal when the map is clicked
func map_clicked(case_index, case_center_coords, occupied):
	if can_place(building_to_place, case_index):
		place(building_to_place, case_index)



func can_place(building, pos):
	# Get the building size
	var size = BuildingsData.get_size(building_to_place)
	
	# Check each case
	for x in range(pos.x, pos.x + size.x):
		for y in range(pos.y, pos.y + size.y):
			# If the case is not free
			if buildings_map.get_cell(x, y) != TileMap.INVALID_CELL:
				return false
				
	# Else the place is free
	return true



func place(building_to_place, pos):
	
	# Get the building size
	var size = BuildingsData.get_size(building_to_place)
	
	# Occupy cases
	for x in range(pos.x, pos.x + size.x):
		for y in range(pos.y, pos.y + size.y):
			buildings_map.set_cell(x, y, occupied_tile)
			
	# Set the building at the main position
	buildings_map.set_cellv(pos, building_to_place)
