extends Node2D

# Enum for the State Machine
enum State {
	STANDARD,
	CHOOSING_PLACE,
	VALIDATING_PLACE
}

# Current State
var state = State.STANDARD


# the buildings Tilemap
onready var buildings_map = $Map/Buildings

# Value of the Occupied Tile
var occupied_tile : int

# The building that will be placed
var building_to_place : int



func _ready():
	#Save the value of the occupied Tile
	occupied_tile = buildings_map.tile_set.find_tile_by_name("Occupied")



## Called from the Map signal when the map is clicked
func map_clicked(case_index, case_center_coords, occupied):
	
	# If Choosing the place
	if state == State.CHOOSING_PLACE:
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



func choose_location(building: int):
	# Defer the change of state so the 
	state = State.CHOOSING_PLACE
	
	building_to_place = building
	
	# Show the Cancel Button
	$CanvasLayer/Cancel.show()
	$CanvasLayer/Build.hide()


func cancel_choose_location():
	# Defer the change of state so the 
	state = State.STANDARD
	
	# Show the Cancel Button
	$CanvasLayer/Cancel.hide()
	$CanvasLayer/Build.show()
