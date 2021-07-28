extends Node2D

# Enum for the State Machine
enum State {
	STANDARD,
	CHOOSING_PLACE,
	ASK_VALIDATION,
	SHOWING_NOTIFICATION,
	SHOWING_DIALOG,
	SHOWING_GUIDE,
	SHOWING_RESULTS
}

# Current State
var state = State.STANDARD

# Manager for scenaristic events
onready var event_manager = $EventManager
onready var dialog_scene = $CanvasLayer/DialogScene

# Name of current event
var current_event = null


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


# Dictionary to count each of the buildings
var buildings_in_city : Dictionary


func _ready():
	#Save the value of the occupied Tile
	occupied_tile = buildings_map.tile_set.find_tile_by_name("Occupied")
	preview_tile = buildings_map.tile_set.find_tile_by_name("FantomBuilding")
	
	# Update the UI
	update_ui()
	
	
	# Enable the camera
	$Camera2D.block_camera(true)



# Tries to trigger a scenaristic
func trigger_scenaristic_event():
	if current_event != null:
		return
	
	# Tries to trigger an event
	var event = event_manager.trigger_event(buildings_in_city)
	
	# If a scenaristic event occured
	if event != null:
		# Keep the event name
		current_event = event
		
		ui.display_notification()



func start_dialog():
	if event_manager.DIALOG_FILES.has(current_event):
		state = State.SHOWING_DIALOG
		
		var dialog_path = event_manager.DIALOG_FILES[current_event]
		print("Dialogue to load : " + dialog_path)
		
		dialog_scene.show()
		dialog_scene.set_process_input(true)
		dialog_scene.start_dialog_event(dialog_path)



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
	PlayerData.use_building(building_name_to_place)
	
	# Add it to the Dictionary
	if not building_name_to_place in buildings_in_city:
		buildings_in_city[building_name_to_place] = 1
	else:
		buildings_in_city[building_name_to_place] += 1


func update_ui():
	# set the population and datapoints
	var pop = PlayerData.city_data[PlayerData.POPULATION]
	var pop_max = PlayerData.city_data[PlayerData.POPULATION_MAX]
	ui.set_population(pop, pop_max)
	ui.set_datapoints(PlayerData.data_points)
	
	# Update the bars from the player data
	ui.update_bars()



func ask_validation():
	print("Ask for validation")
	
	state = State.ASK_VALIDATION
	
	# show the preview emplacements
	show_preview()
	
	# Disable the camera
	$Camera2D.block_camera(false)
	
	
	# Show the validation popup after a small delay
	yield(get_tree().create_timer(1.0), "timeout") # Delay
	ui.show_validation_popup()


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
	for b in PlayerData.building_list.keys():
		# Get the amount left
		var count = PlayerData.building_list[b]
		
		if count > 0 or count == PlayerData.INF_BUILDING:
			build_menu.add_building(b, count)



func give_event_result():
	# Give the building to the player *(given no matter the result)*
	var new_buildings = event_manager.OFFERED_BUILDINGS.get(current_event, {})
	
	# For each building to give
	for b in new_buildings.keys():
		# Get the count
		var count = new_buildings[b]
		# Add it
		PlayerData.add_building(b, count)
		
	
	# Show the Result window
	show_results(dialog_scene.get_points_gained(), dialog_scene.get_buildings_gained())
	
	
	# Update the Player Points
	PlayerData.data_points += dialog_scene.get_points_gained()
	
	# Give the buildings
	for building in dialog_scene.get_buildings_gained():
		PlayerData.add_building(building, 1)




func show_results(points_gained: int, buildings_gained: Array):
	# If no points and no buildings, just leave
	if points_gained == 0 and buildings_gained.empty():
		state = State.STANDARD
		return
	
	
	# Set the logical state
	state = State.SHOWING_RESULTS
	
	# Show the window
	ui.hide()
	$CanvasLayer/EventResult.show()
	
	# Set the point display
	$CanvasLayer/EventResult.set_points_gained(dialog_scene.get_points_gained())
	
	# Set the buildings gained
	for building in dialog_scene.get_buildings_gained():
		$CanvasLayer/EventResult.add_building(building)



#========> UI Calls <========#

func _on_CityUI_open_notifications():
	# only if State.STANDARD
	if state == State.STANDARD:
		print("Open Notifications !")
		
		state = State.SHOWING_NOTIFICATION
		
		# Show the notification with the summary
		var summary = event_manager.SUMMARIES.get(current_event, "No summary found for " + current_event)
		ui.show_notifications(summary)




func _on_CityUI_open_settings():
	# only if State.STANDARD
	if state == State.STANDARD:
		print("Open Settings !")



func _on_CityUI_logout():
	print("Logout !")
	get_tree().quit()



func _on_CityUI_open_build():
	if state == State.STANDARD:
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
	if state == State.STANDARD:
		print("Open Guide !")
	
		state = State.SHOWING_GUIDE
		
		ui.hide()
		$CanvasLayer/GuideOpenData.show()
		
		# Disable the camera
		$Camera2D.block_camera(true)


func _on_CityUI_cancel_build():
	print("Cancel the build")
	ui.show_build_button()
	
	state = State.STANDARD


func _on_CityUI_unvalidate_position():
	print("Unvalidate position !")
	
	# Reset the UI
	ui.show_build_button()
	
	# Hide the preview cases
	hide_preview()
	
	state = State.STANDARD


func _on_CityUI_validate_position():
	print("Validate position !")
	
	# Reset the UI
	ui.show_build_button()
	
	# Place the building
	build(building_to_place, building_case)
	
	# Try to trigger an event
	trigger_scenaristic_event()
	
	# Update the UI with player_data
	update_ui()
	
	state = State.STANDARD



func _on_CityUI_start_dialog():
	print("Start a dialog !")
	start_dialog()
	


func _on_CityUI_close_notifications():
	print("Closing notification")
	
	# There is still a waiitng notification
	ui.close_notifications(true)
	
	state = State.STANDARD


func _on_DialogScene_dialog_finished():
	print("Dialog finished")
	
	# For the time being, switch to Standard state
	state = State.STANDARD
	
	# Give the result of the event
	give_event_result()
	
	
	# If the Dialog must not be done again, save it
	if not dialog_scene.must_redo_dialog():
		# Add the event to the Player count
		PlayerData.add_event_occurence(current_event)
	
	
	# Clear the current event
	current_event = null
	
	# There is no notification waiting
	ui.close_notifications(false)
	
	# Hide the dialog scene and stop it from managin inputs
	dialog_scene.hide()
	dialog_scene.set_process_input(false)
	
	# Update the UI with the new scores
	update_ui()


func _on_GuidOpenData_close_guide():
	print("Closing Guide")
	
	state = State.STANDARD
	
	ui.show()
	$CanvasLayer/GuideOpenData.hide()

	# Enable the camera
	$Camera2D.block_camera(false)



func _on_EventResult_close_results():
	print("Closing Results")
	
	state = State.STANDARD
	
	# Show the ui and hide the results
	ui.show()
	$CanvasLayer/EventResult.hide()

	# Enable the camera
	$Camera2D.block_camera(false)


func _on_CityUI_closed_tutorial():
	# Enable the camera
	$Camera2D.block_camera(false)
