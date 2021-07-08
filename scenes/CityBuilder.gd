extends Node2D

# Enum for the State Machine
enum State {
	STANDARD,
	CHOOSING_PLACE,
	ASK_VALIDATION
}

# Current State
var state = State.STANDARD

# Reference to the UI
onready var ui = $CanvasLayer/CityUI
onready var build_menu = $CanvasLayer/BuildMenu

# the buildings Tilemap
onready var buildings_map = $Map/Buildings

# Value of the Occupied and preview Tile
var occupied_tile : int
var preview_tile : int

# The building that will be placed
var building_to_place : int
var building_name_to_place : String
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



func build(building: int, pos: Vector2):
	# Get the building size
	var size = BuildingsData.get_size(building)
	
	# Occupy cases
	for x in range(pos.x, pos.x - size.x, -1):
		for y in range(pos.y, pos.y - size.y, -1):
			buildings_map.set_cell(x, y, 1)
			
	# Set the building at the main position
	buildings_map.set_cellv(pos, building)
	
	
	# Remove from the player list
	PlayerData.building_list[building_name_to_place] -= 1



func ask_validation():
	print("Ask for validation")
	
	state = State.ASK_VALIDATION
	
	# Show the validation popup
	ui.show_validation_popup()
	
	# show the preview emplacements
	show_preview()
	
	# Disable the camera
	$Camera2D.block_camera(false)



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



func set_building_menu():
	# Add random buildings
	for building_name in PlayerData.building_list.keys():
		# Get the amount left
		var count = PlayerData.building_list[building_name]
		
		if count > 0:
			build_menu.add_building(building_name, count)



#========> UI Calls <========#

func _on_CityUI_open_notifications():
	# IGNORE IF NOT State.STANDARD
	print("Open Notifications !")



func _on_CityUI_open_settings():
	# IGNORE IF NOT State.STANDARD
	print("Open Settings !")



func _on_CityUI_logout():
	print("Logout !")
	get_tree().quit()



func _on_CityUI_open_build():
	ui.hide()
	build_menu.show()
	
	# Set the buildings 
	set_building_menu()
	
	# Disable the camera
	$Camera2D.block_camera(true)



func _on_BuildMenu_selected_building(building_name):
	print("Selected : " + building_name)
	
	# Change state to choosing place
	state = State.CHOOSING_PLACE
	
	# Save the building
	building_name_to_place = building_name
	building_to_place = buildings_map.tile_set.find_tile_by_name(building_name)
	
	# Update UI Elements displayed
	ui.show()
	build_menu.hide()
	
	# Set the ui to show the building
	ui.show_current_building(building_name)
	
	
	# Disable the camera
	$Camera2D.block_camera(false)



func _on_BuildMenu_exited_build_menu():
	print("Exit build menu")
	
	ui.show()
	build_menu.hide()
	
	# Disable the camera
	$Camera2D.block_camera(false)



func _on_CityUI_open_guide():
	# IGNORE IF NOT State.STANDARD
	print("Open Guide !")


func _on_CityUI_cancel_build():
	print("Cancel the build")
	ui.show_build_button()


func _on_CityUI_unvalidate_position():
	print("Unvalidate position !")
	
	# Reset the UI
	ui.show_build_button()
	
	# Hide the preview cases
	hide_preview()
	
	state = State.STANDARD


func _on_CityUI_validate_position():
	print("Validate position !")
	
	# Place the building
	build(building_to_place, building_case)
	
	# Reset the UI
	ui.show_build_button()
	
	state = State.STANDARD
