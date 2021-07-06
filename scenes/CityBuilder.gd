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

# Value of the Occupied and preview Tile
var occupied_tile : int
var preview_tile : int

# The building that will be placed
var building_to_place : int
var building_case : Vector2
var build_case_center : Vector2



func _ready():
	#Save the value of the occupied Tile
	occupied_tile = buildings_map.tile_set.find_tile_by_name("Occupied")
	preview_tile = buildings_map.tile_set.find_tile_by_name("FantomBuilding")



## Called from the Map signal when the map is clicked
func map_clicked(case_index, case_center_coords, _occupied):
	
	# If Choosing the place
	if state == State.CHOOSING_PLACE:
		if can_place(building_to_place, case_index):
			# Save the location
			building_case = case_index
			build_case_center = case_center_coords
			
			# Ask for validation
			ask_validation()



func can_place(building, pos):
	# Get the building size
	var size = BuildingsData.get_size(building)
	
	# Check each case
	for x in range(pos.x, pos.x - size.x, -1):
		for y in range(pos.y, pos.y - size.y, -1):
			# If the case is not free
			if buildings_map.get_cell(x, y) != TileMap.INVALID_CELL:
				return false
	
	# Else the place is free
	return true



func place(building: int, pos: Vector2):
	# Get the building size
	var size = BuildingsData.get_size(building)
	
	# Occupy cases
	for x in range(pos.x, pos.x - size.x, -1):
		for y in range(pos.y, pos.y - size.y, -1):
			buildings_map.set_cell(x, y, 1)
			
	# Set the building at the main position
	buildings_map.set_cellv(pos, building)



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
	$CanvasLayer/Validate.hide()
	$CanvasLayer/Build.show()
	
	hide_preview()




func ask_validation():
	# Defer the change of state so the 
	state = State.VALIDATING_PLACE
	
	# Show the Cancel Button
	$CanvasLayer/Validate.show()
	
	# Set the Preview
	show_preview()



func show_preview():
	# Get the building size
	var size = BuildingsData.get_size(building_to_place)
	
	for x in range(building_case.x, building_case.x - size.x, -1):
		for y in range(building_case.y, building_case.y - size.y, -1):
			buildings_map.set_cell(x, y, preview_tile)

func hide_preview():
	# Get the building size
	var size = BuildingsData.get_size(building_to_place)
	
	for x in range(building_case.x, building_case.x - size.x, -1):
		for y in range(building_case.y, building_case.y - size.y, -1):
			buildings_map.set_cell(x, y, TileMap.INVALID_CELL)



func validate():
	#Call Cancel location as they do the same things
	cancel_choose_location()
	
	# Place the building
	place(building_to_place, building_case)
	
	print("Validate place !")
