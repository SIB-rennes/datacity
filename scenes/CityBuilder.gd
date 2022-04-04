extends Node2D

onready var dialog_tuto_line = $CanvasLayer/dialog_tuto/text/DialogLine
onready var dialog_tuto = $CanvasLayer/dialog_tuto
onready var city_shadow = $CanvasModulate
onready var ui_shadow = $CanvasLayer/CityUI/CanvasModulate
onready var building_button = $CanvasLayer/CityUI/Panel/Panel/MarginBuild/HBoxContainer/BuildContainer/BuildButton
onready var building_card_build = $CanvasLayer/BuildMenu/background/MarginContainer/ScrollContainer/building_container/BuildingButton/Background
onready var building_card_build_sprite = $CanvasLayer/BuildMenu/background/MarginContainer/ScrollContainer/building_container/BuildingButton/Building/BuildingContainer/BuildingSprite
onready var build_shadow = $CanvasLayer/BuildMenu/CanvasModulate
onready var guide_button = $CanvasLayer/CityUI/Panel/MarginContainer/TopRightContainer/GuideButton
onready var building_card_button = $CanvasLayer/BuildMenu/background/MarginContainer/ScrollContainer/building_container/BuildingButton
onready var destroy_button = $CanvasLayer/CityUI/Panel/Panel/DestructionContainer/DestroyButton
onready var map_1 = $Map
onready var map_2 = $Map2
onready var map_3 = $Map3

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

enum State_tuto {
	START_TUTO
	BUILDING_BUTTON,
	INFO_BUILDING,
	INFO_BUILDING_2,
	INFO_BUILDING_3,
	INFO_BUILDING_LAST,
	BUILDING_POSE,
	INFOS_UI,
	INCOMES,
	INFOS_UI_2,
	INFOS_UI_LAST,
	INFOS_EVENT,
	EVENT_BUTTON,
	EVENT_LAUNCHED,
	EVENT_FINISH,
	INFOS_RESULT,
	INFOS_RESULT_2,
	INFOS_RESULT_LAST,
	GUIDE_TUTO,
	GUIDE_OPENED,
	LAST_TUTO,
	TUTO_FINISHED
}

# Current State
var state = State.STANDARD

#Event Timer:
var timer_launched = false
var timer_paused = false
var notif_scenar = false

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
onready var buildings_map2 = $Map2/Buildings
onready var buildings_map3 = $Map3/Buildings
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

#tutorial variables
var tuto_build = true
var tuto_completed = false
var current_tuto = State_tuto.START_TUTO
var next_tuto = State_tuto.BUILDING_BUTTON
var can_click = false
var can_use = "not_defined"

#notification new building variable
var notif_building = false

#var
var build_opened = false 
var destruction_launched = false
var destruction_now = false

var case_index_saved
var cancel_hovered = false
var building = ""
var building_id = 0

var can_place_positions = []

func _ready():
	print("PLAYER DATA MAP : ", PlayerData.map)
	building_button.material.set_light_mode(0)
	if PlayerData.map == "map1":
		PlayerData.can_place_position = buildings_map.get_used_cells_by_id(48)
		print("CAN PLACE POSITION", can_place_positions)
		print("PLAYER DATA CAN PLACE POSITION", PlayerData.can_place_position)
		print("MAP 1 !!")
		map_1.show()
		if "AmenagementCyclable" in PlayerData.event_occured:
			$Map/Roads_cycles_and_bus.show()
			print("CYCLE")
		else:
			$Map/Roads_cycles_and_bus.hide()
			print("NO_CYCLE")
		$AnimationPlayer.play("ship")
		$AnimationPlayer2.play("Wave")
		$BirdAnimationPlayer.play("birds")
#		get_incomes()
		if PlayerData.save_found == true:
			tuto_completed = true
		if tuto_completed == false:
			ui.close_tutorial()
		print(PlayerData.gender)
		$Map/Buildings/preview.hide()
		$Map2/Buildings/preview.hide()
		$Map3/Buildings/preview.hide()
		dialog_tuto.rect_position = Vector2(492, 280)
		$CanvasLayer/dialog_tuto/text.rect_size = Vector2(342, 192)
		$CanvasLayer/dialog_tuto/text/DialogLine.rect_size = Vector2(327, 149)
		$CanvasLayer/CityUI/Panel/TutorialCity.show()
		# Blocks the camera if there is a tutorial
		$Camera2D.block_camera(true)
	if PlayerData.map == "map2":
		can_place_positions = buildings_map2.get_used_cells_by_id(48)
		PlayerData.can_place_position = can_place_positions
		print("MAP 2 !!")
		map_2.show()
		if "AmenagementCyclable" in PlayerData.event_occured:
			$Map2/Roads_cycles_and_bus.show()
			print("CYCLE")
		else:
			$Map2/Roads_cycles_and_bus.hide()
			print("NO_CYCLE")
		$BirdAnimationPlayer.play("birds")
#		get_incomes()
		if PlayerData.save_found == true:
			tuto_completed = true
		if tuto_completed == false:
			ui.close_tutorial()
		print(PlayerData.gender)
		$Map/Buildings/preview.hide()
		$Map2/Buildings/preview.hide()
		$Map3/Buildings/preview.hide()
		dialog_tuto.rect_position = Vector2(492, 280)
		$CanvasLayer/dialog_tuto/text.rect_size = Vector2(342, 192)
		$CanvasLayer/dialog_tuto/text/DialogLine.rect_size = Vector2(327, 149)
		$CanvasLayer/CityUI/Panel/TutorialCity.show()
		# Blocks the camera if there is a tutorial
		$Camera2D.block_camera(true)
	if PlayerData.map == "map3":
		can_place_positions = buildings_map3.get_used_cells_by_id(48)
		PlayerData.can_place_position = can_place_positions
		print("MAP 3 !!")
		map_3.show()
		if "AmenagementCyclable" in PlayerData.event_occured:
			$Map3/Roads_cycles_and_bus.show()
			print("CYCLE")
		else:
			$Map3/Roads_cycles_and_bus.hide()
			print("NO_CYCLE")
		$BirdAnimationPlayer.play("birds")
#		get_incomes()
		if PlayerData.save_found == true:
			tuto_completed = true
		if tuto_completed == false:
			ui.close_tutorial()
		print(PlayerData.gender)
		$Map/Buildings/preview.hide()
		$Map2/Buildings/preview.hide()
		$Map3/Buildings/preview.hide()
		dialog_tuto.rect_position = Vector2(492, 280)
		$CanvasLayer/dialog_tuto/text.rect_size = Vector2(342, 192)
		$CanvasLayer/dialog_tuto/text/DialogLine.rect_size = Vector2(327, 149)
		$CanvasLayer/CityUI/Panel/TutorialCity.show()
		# Blocks the camera if there is a tutorial
		$Camera2D.block_camera(true)

	if PlayerData.must_load_save:
#			get_incomes()
			print ("Must load save")
			if load_save():
				if PlayerData.tuto_advancement == true:
					tuto_completed = true
				print(PlayerData.map)
				if PlayerData.map == "map1":
					$Map.show()
					$Map/Buildings/preview.hide()
					$Map2/Buildings/preview.hide()
					$Map3/Buildings/preview.hide()
					$AnimationPlayer.play("ship")
					$AnimationPlayer2.play("Wave")
					$BirdAnimationPlayer.play("birds")
				if PlayerData.map == "map2":
					print("SAVE MAP2")
					$Map2.show()
					$Map/Buildings/preview.hide()
					$Map3/Buildings/preview.hide()
					$Map2/Buildings/preview.hide()
					$BirdAnimationPlayer.play("birds")
				if PlayerData.map == "map3":
					$Map3.show()
					$Map/Buildings/preview.hide()
					$Map2/Buildings/preview.hide()
					$Map3/Buildings/preview.hide()
					$BirdAnimationPlayer.play("birds")
				print("MAP LOAD: ", PlayerData.map)
				print("Save loaded !")
				# Hides the tutorial
				ui.close_tutorial()
				update_ui()
#Save the value of the occupied Tile
	if PlayerData.map == "map1":
		occupied_tile = buildings_map.tile_set.find_tile_by_name("Occupied")
		preview_tile = buildings_map.tile_set.find_tile_by_name("FantomBuilding")
	elif PlayerData.map == "map2":
		occupied_tile = buildings_map2.tile_set.find_tile_by_name("Occupied")
		preview_tile = buildings_map2.tile_set.find_tile_by_name("FantomBuilding")
	elif PlayerData.map == "map3":
		occupied_tile = buildings_map3.tile_set.find_tile_by_name("Occupied")
		preview_tile = buildings_map3.tile_set.find_tile_by_name("FantomBuilding")
	$CanvasLayer/DialogScene.can_show_desk = true

#func get_incomes():
#
#	get_incomes()

# Tries to trigger a scenaristic
func trigger_scenaristic_event():
	print("try to trigger")
	if current_event != null:
		return
	
	# Tries to trigger an event
	var event = event_manager.trigger_event(buildings_in_city)
	
	# If a scenaristic event occured and the dialog has a file
	if event != null:
		# If there is no corresponding dialog file
		if not event_manager.DIALOG_FILES.has(event):
			timer_launched = false
			notif_scenar = false
			print("ERROR : no dialogue file specified for " + event)
			return
		# Get the dialogue file and check if it exists
		var file_path = event_manager.DIALOG_FILES.get(event, null)
		
		if not File.new().file_exists(file_path):
			timer_launched = false
			notif_scenar = false
			print("ERROR : the dialogue file for " + event + " doesn't exist")
			return
		# Keep the event name
		current_event = event
		
		ui.display_notification()
	else:
		timer_launched = false
		notif_scenar = false

func start_dialog():
	PlayerData.can_show_desk = true
	if event_manager.DIALOG_FILES.has(current_event):
		state = State.SHOWING_DIALOG
		
		var dialog_path = event_manager.DIALOG_FILES[current_event]
		print("Dialogue to load : " + dialog_path)
		
		dialog_scene.show()
		dialog_scene.set_process_input(true)
		dialog_scene.start_dialog_event(dialog_path)

# warning-ignore:unused_argument
func _physics_process(delta):
	if PlayerData.map == "map1":
		if state == State.CHOOSING_PLACE:
			check_preview(building_to_place, $Map/Buildings.tile)
	elif PlayerData.map == "map2":
		if state == State.CHOOSING_PLACE:
			check_preview(building_to_place, $Map2/Buildings.tile)
	elif PlayerData.map == "map3":
		if state == State.CHOOSING_PLACE:
			check_preview(building_to_place, $Map3/Buildings.tile)
	if timer_launched == false && notif_scenar == false && tuto_completed == true:
		timer_launched = true
		$ScenaristicTimer.start()

	
func check_preview(building, pos):
	var constructible = false
	var occupied = false
# Get the building size
	var size = BuildingsData.get_size(building)
	# Check each case
	for x in range(pos.x, pos.x - size.x, - 1):
		for y in range(pos.y, pos.y + size.y, + 1):
			if PlayerData.map == "map1":
				if buildings_map.get_cell(x,y) == 48:
					constructible = true
				else:
					#check if the others case are occupied.
					if buildings_map.get_cell(x, y) != TileMap.INVALID_CELL:
						occupied = true
			elif PlayerData.map == "map2":
				if buildings_map2.get_cell(x,y) == 48:
					constructible = true
				else:
				#check if the others case are occupied.
					if buildings_map2.get_cell(x, y) != TileMap.INVALID_CELL:
						occupied = true
			elif PlayerData.map == "map3":
				if buildings_map3.get_cell(x,y) == 48:
					constructible = true
				else:
				#check if the others case are occupied.
					if buildings_map3.get_cell(x, y) != TileMap.INVALID_CELL:
						occupied = true
			# Check if a case is a constructible_tile
#if there is a constructible tile and the other tile are not occupied, you can build.
	if constructible && !occupied:
		if PlayerData.map == "map1":
			$Map/Buildings.can_place = true
		elif PlayerData.map == "map2":
			$Map2/Buildings.can_place = true
		elif PlayerData.map == "map3":
			$Map3/Buildings.can_place = true
	else:
		if PlayerData.map == "map1":
			$Map/Buildings.can_place = false
		elif PlayerData.map == "map2":
			$Map2/Buildings.can_place = false
		elif PlayerData.map == "map3":
			$Map3/Buildings.can_place = false

## Called from the Map signal when the map is clicked


func map_clicked(case_index, case_center_coords, _occupied):
	# If Choosing the place
	if destruction_launched == false:
		if state == State.CHOOSING_PLACE:
			if can_place(building_to_place, case_index):
				# Save the location
				building_case = case_index
				build_case_center = case_center_coords
				if PlayerData.map == "map1":
					$Map/Buildings/preview.position = case_center_coords
					$Map/Buildings.validation = true
				elif PlayerData.map == "map2":
					$Map2/Buildings/preview.position = case_center_coords
					$Map2/Buildings.validation = true
				elif PlayerData.map == "map3":
					$Map3/Buildings/preview.position = case_center_coords
					$Map3/Buildings.validation = true
			# Ask for validation
				ask_validation()
			else:
				if PlayerData.map == "map1":
					$Map/Buildings.can_place = false
				elif PlayerData.map == "map2":
					$Map2/Buildings.can_place = false
				elif PlayerData.map == "map3":
					$Map3/Buildings.can_place = false

	# If the player destroy buildings when he click
	if destruction_launched == true and build_opened == false and destruction_now == false:
		if PlayerData.map == "map1":
			if buildings_map.get_cell(case_index.x, case_index.y) != TileMap.INVALID_CELL:
				if buildings_map.get_cell(case_index.x, case_index.y) != 48 && buildings_map.get_cell(case_index.x, case_index.y) != 28 && buildings_map.get_cell(case_index.x, case_index.y) != 1:
					case_index_saved = case_index
					building_id = buildings_map.get_cell(case_index_saved.x, case_index_saved.y)
					building = buildings_map.tile_set.tile_get_name(building_id)
					if building in PlayerData.building_list:
						print("id : ", building_id)
	#					if building_id != 1:
						print("name of this building : "+ building)
						if cancel_hovered == false:
	#						if building in PlayerData.building_list:
							destruction_now = true
							ask_validation()

		elif PlayerData.map == "map2":
			if buildings_map2.get_cell(case_index.x, case_index.y) != TileMap.INVALID_CELL:
				if buildings_map2.get_cell(case_index.x, case_index.y) != 48 && buildings_map2.get_cell(case_index.x, case_index.y) != 28 && buildings_map2.get_cell(case_index.x, case_index.y) != 1:
					case_index_saved = case_index
					building_id = buildings_map2.get_cell(case_index_saved.x, case_index_saved.y)
					building = buildings_map2.tile_set.tile_get_name(building_id)
					if building in PlayerData.building_list:
						print("id : ", building_id)
	#					if building_id != 1:
						print("name of this building : " + building)
						if cancel_hovered == false:
	#						if building in PlayerData.building_list:
							destruction_now = true
							ask_validation()
		elif PlayerData.map == "map3":
			if buildings_map3.get_cell(case_index.x, case_index.y) != TileMap.INVALID_CELL:
				if buildings_map3.get_cell(case_index.x, case_index.y) != 48 && buildings_map3.get_cell(case_index.x, case_index.y) != 28 && buildings_map3.get_cell(case_index.x, case_index.y) != 1:
					case_index_saved = case_index
					building_id = buildings_map3.get_cell(case_index_saved.x, case_index_saved.y)
					building = buildings_map3.tile_set.tile_get_name(building_id)
					if building in PlayerData.building_list:
						print("id : ", building_id)
	#					if building_id != 1:
						print("name of this building : "+ building)
						if cancel_hovered == false:
	#						if building in PlayerData.building_list:
							destruction_now = true
							ask_validation()

func can_place(building, pos):
	var constructible = false
	var occupied = false
	# Get the building size
	var size = BuildingsData.get_size(building)
	for x in range(pos.x, pos.x - size.x, - 1):
		for y in range(pos.y, pos.y + size.y, + 1):
			# If the case is not free
#			if buildings_map.get_cell(x, y) != TileMap.INVALID_CELL or 
			print("x : ", + x)
			print("y : ", + y)
			if PlayerData.map == "map1":
				if buildings_map.get_cell(x,y) == 48:
					print("constructible map1")
					constructible = true
				else:
					if buildings_map.get_cell(x, y) != TileMap.INVALID_CELL:
						print("occupied map1")
						occupied = true
			elif PlayerData.map == "map2":
				if buildings_map2.get_cell(x,y) == 48:
					print("constructible map2")
					constructible = true
				else:
					if buildings_map2.get_cell(x, y) != TileMap.INVALID_CELL:
						print("occupied map2")
						occupied = true
			elif PlayerData.map == "map3":
				if buildings_map3.get_cell(x,y) == 48:
					print("constructible map3")
					constructible = true
				else:
					if buildings_map3.get_cell(x, y) != TileMap.INVALID_CELL:
						print("occupied map3")
						occupied = true


	if constructible && !occupied:
		return true
	else:
		return false
				
	# Else the place is free

func build(building: int, pos: Vector2):
	# Get the building size
	var size = BuildingsData.get_size(building)

	# Occupy cases
	for x in range(pos.x, pos.x - size.x, - 1):
		for y in range(pos.y, pos.y + size.y, + 1):
			if PlayerData.map == "map1":
				buildings_map.set_cell(x, y, 1)
			elif PlayerData.map == "map2":
				buildings_map2.set_cell(x, y, 1)
			elif PlayerData.map == "map3":
				buildings_map3.set_cell(x, y, 1)

	# Set the building at the main position
	if PlayerData.map == "map1":
		buildings_map.set_cellv(pos, building)
	elif PlayerData.map == "map2":
		buildings_map2.set_cellv(pos, building)
	elif PlayerData.map == "map3":
		buildings_map3.set_cellv(pos, building)
	# Remove from the player list
	PlayerData.use_building(building_name_to_place)

	# Add it to the Dictionary
	if not building_name_to_place in buildings_in_city:
		buildings_in_city[building_name_to_place] = 1
	else:
		buildings_in_city[building_name_to_place] += 1

func destruction():
	if destruction_launched == true and destruction_now == true:
		ui.confirmation_container.hide()
		ui.show_build_button()
		state = State.STANDARD
		PlayerData.recover(building)
		
		if building_id != 1 and building in PlayerData.building_list:
			restore_can_place(case_index_saved)
			if building in BuildingsData.MEDIUM_BUILDING or building in BuildingsData.BIG_BUILDING:
				case_index_saved.x -= 1
				restore_can_place(case_index_saved)
				case_index_saved.y += 1
				restore_can_place(case_index_saved)
				case_index_saved.x += 1
				restore_can_place(case_index_saved)
				if building in BuildingsData.BIG_BUILDING:
					case_index_saved.y += 1
					restore_can_place(case_index_saved)
					case_index_saved.x -= 1
					restore_can_place(case_index_saved)
					case_index_saved.x -= 1
					restore_can_place(case_index_saved)
					case_index_saved.y -= 1
					restore_can_place(case_index_saved)
					case_index_saved.y -= 1
					restore_can_place(case_index_saved)
		destroy_button.show()
		
		update_ui()
		
		$Camera2D.block_camera(false)
		
		build_opened = false
		destruction_now = false
		destruction_launched = false
		
		save()

func restore_can_place(coords: Vector2):
	print(PlayerData.map)
	if PlayerData.map == "map1":
		print("RESTORE MAP 1")
		if coords in PlayerData.can_place_position:
			print("COORDS IN CAN PLACE", coords)
			buildings_map.set_cell(coords.x, coords.y, 48)
		else:
			#It's bug when you reload the game, the tiles where you put buildings will not restore "can_place" tiles (but it's works correctly when while you don't reload)
			print("NO COORDS ? !! BEFORE", coords)
#			print("CAN PLACE_POS:", PlayerData.can_place_position)
			print("NO COORDS ? !!", coords)
			buildings_map.set_cell(coords.x, coords.y, -1)
	elif PlayerData.map == "map2":
		print("RESTORE MAP 2")
		if coords in PlayerData.can_place_position:
			buildings_map2.set_cell(coords.x, coords.y, 48)
		else:
			buildings_map2.set_cell(coords.x, coords.y, -1)
	elif PlayerData.map == "map3":
		print("RESTORE MAP 3")
		if coords in PlayerData.can_place_position:
			buildings_map3.set_cell(coords.x, coords.y, 48)
		else:
			buildings_map3.set_cell(coords.x, coords.y, -1)

func update_ui():
	# set the population and datapoints
	var pop = PlayerData.city_data[PlayerData.POPULATION]
	var pop_max = PlayerData.city_data[PlayerData.POPULATION_MAX]
	ui.set_population(pop, pop_max)
	ui.set_datapoints(PlayerData.data_points)
	
	# Update the bars from the player data
	ui.update_bars()

	if current_event != null:
		ui.display_notification()

func ask_validation():
	print("VALIDATION")
	state = State.ASK_VALIDATION

	# show the preview emplacements

	# Disable the camera
	$Camera2D.block_camera(true)
	# Show the validation popup after a small delay
	ui.show_validation_buttons()

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
	
	# Show the Result window
	show_results(dialog_scene.get_points_gained(), dialog_scene.get_buildings_gained())
	
	# Update the Player Points
	PlayerData.data_points += dialog_scene.get_points_gained()
	
	# Give the buildings
	for building in dialog_scene.get_buildings_gained():
		var count = new_buildings[building]
		PlayerData.add_building(building, count)

func show_results(points_gained: int, buildings_gained: Array):
	var new_buildings = event_manager.OFFERED_BUILDINGS.get(current_event, {})
	
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
		var count = new_buildings[building]

		$CanvasLayer/EventResult.add_building(building, count)

#========> UI Calls <========#

func _on_CityUI_open_notifications():
	if tuto_completed == true or can_use == "event_button":
		if build_opened == false:
	# only if State.STANDARD
			if state == State.STANDARD:
				state = State.SHOWING_NOTIFICATION
			
			# Show the notification with the summary
				var summary = event_manager.SUMMARIES.get(current_event, "No summary found for " + current_event)
				ui.show_notifications(summary)

func _on_CityUI_open_settings():
	if tuto_completed == true:
	# only if State.STANDARD
		if state == State.STANDARD:
		# Here, open the Settings (not used)
			pass

func _on_CityUI_logout():
	get_tree().quit()

func _on_CityUI_cancel_build():
	if state == State.CHOOSING_PLACE or state == State.ASK_VALIDATION:
		ui.show_build_button()
		
		state = State.STANDARD
		state = State.STANDARD
		$Map/Buildings/preview.hide()
		$Map2/Buildings/preview.hide()
		$Map3/Buildings/preview.hide()
		if PlayerData.map == "map1":
			buildings_map.show_constructible_tile(false)
		if PlayerData.map == "map2":
			buildings_map2.show_constructible_tile(false)
		if PlayerData.map == "map1":
			buildings_map3.show_constructible_tile(false)
		
		if timer_paused == true:
			timer_paused = false
			$ScenaristicTimer.paused = false
		build_opened = false
		destroy_button.show()
		destruction_launched = false
		cancel_hovered = false
		$Camera2D.block_camera(false)
		ui.confirmation_container.hide()

func _on_CityUI_open_build():
	if build_opened == false:
		if tuto_completed == true or can_use == "building_button" or can_use == "select_building" or can_use == "pose_building":
			if can_use == "building_button":
				listen_state_data()

			if state == State.STANDARD:
				build_menu.show()
				if can_use == "select_building" or can_use == "pose_building":
					$CanvasLayer/place_building_tuto.hide()
			
			# Set the buildings 
				set_building_menu()
				
				# Disable the camera
				$Camera2D.block_camera(true)
				
				build_opened = true

func _on_BuildMenu_selected_building(building_name):
	if tuto_completed == true or can_use == "building_button" or can_use == "select_building" or can_use == "pose_building":
		if can_use == "select_building":
			listen_state_data()
			
		if PlayerData.data_points - BuildingsData.PRIX[building_name] < 0:
			open_no_datapoints()
		else:
		# Save the building
			building_name_to_place = building_name
			if PlayerData.map == "map1":
				building_to_place = buildings_map.tile_set.find_tile_by_name(building_name)
			elif PlayerData.map == "map2":
				building_to_place = buildings_map2.tile_set.find_tile_by_name(building_name)
			elif PlayerData.map == "map3":
				building_to_place = buildings_map3.tile_set.find_tile_by_name(building_name)
			# Update UI Elements displayed
			ui.show()
			build_menu.hide()
			print(can_use)
			if can_use == "pose_building":
				$CanvasLayer/place_building_tuto.show()
			
			# Set the ui to show the building
			ui.show_current_building(building_name)
			
			# Disable the camera
			$Camera2D.block_camera(false)
			
			update_preview()

			yield(get_tree().create_timer(0.3), "timeout")
			# Change state to choosing place
			state = State.CHOOSING_PLACE
			build_menu.modulate_all(null)

func _on_BuildMenu_exited_build_menu():
	if tuto_completed == true:
		ui.show()
		build_menu.hide()
	# Disable the camera
		$Camera2D.block_camera(false)
		
		build_opened = false
		
		if timer_launched == true:
			timer_paused = false
			$ScenaristicTimer.paused = false
		build_menu.modulate_all(null)

func _on_CityUI_open_guide():
	if tuto_completed == true or can_use == "guide":
		if can_use == "guide":
			listen_state_data()

	# IGNORE IF NOT State.STANDARD
		if state == State.STANDARD:
			state = State.SHOWING_GUIDE
			
			ui.hide()
			$CanvasLayer/GuideOpenData.show()
			
			# Disable the camera
			$Camera2D.block_camera(true)

func _on_CityUI_unvalidate_position():
	if destruction_launched == false:
	# Hide the preview cases
		if PlayerData.map == "map1":
			buildings_map.validation = false
		if PlayerData.map == "map2":
			buildings_map2.validation = false
		if PlayerData.map == "map3":
			buildings_map3.validation = false
		ui.confirmation_container.hide()
		yield(get_tree().create_timer(0.3), "timeout")
		state = State.CHOOSING_PLACE
		if timer_paused == true:
			timer_paused = false
			$ScenaristicTimer.paused = false
	else:
		ui.confirmation_container.hide()
		state = State.CHOOSING_PLACE
		buildings_map.validation = false
		destruction_now = false
	$Camera2D.block_camera(false)

func _on_CityUI_validate_position():
	if destruction_launched == false:
		ui.confirmation_container.hide()
		if can_use == "pose_building":
			listen_state_data()
		# Reset the UI
		ui.show_build_button()
		
		# Place the building
		build(building_to_place, building_case)
		
		# Try to trigger an event
		trigger_scenaristic_event()
		
		# Update the UI with player_data
		update_ui()
		if PlayerData.map == "map1":
			$Map/Buildings/preview.hide()
		elif PlayerData.map == "map2":
			$Map2/Buildings/preview.hide()
		elif PlayerData.map == "map3":
			$Map3/Buildings/preview.hide()
		state = State.STANDARD
		if PlayerData.map == "map1":
			buildings_map.show_constructible_tile(false)
		if PlayerData.map == "map2":
			buildings_map2.show_constructible_tile(false)
		if PlayerData.map == "map3":
			buildings_map3.show_constructible_tile(false)
		
		if timer_paused == true:
			timer_paused = false
			$ScenaristicTimer.paused = false
		
		build_opened = false
		$Camera2D.block_camera(false)
		# Save the game 
		save()

func _on_CityUI_start_dialog():
	if tuto_completed == true or can_use == "event_button":
		if can_use == "event_button":
			listen_state_data()
		start_dialog()


func _on_CityUI_close_notifications():
	# There is still a waiitng notification
	ui.close_notifications(true)
	
	state = State.STANDARD


func _on_DialogScene_dialog_finished():
	if tuto_completed == false:
		listen_state_data()
	# For the time being, switch to Standard state
	state = State.STANDARD
	
	# Give the result of the event
	give_event_result()

	# If the Dialog must not be done again, save it
	if not dialog_scene.must_redo_dialog():
		# Add the event to the Player count
		PlayerData.add_event_occurence(current_event)
		print("CURRENT EVENT: ", current_event)


	# Clear the current event
	current_event = null
	notif_scenar = false
	# There is no notification waiting
	ui.close_notifications(false)

	# Hide the dialog scene and stop it from managin inputs
	dialog_scene.hide()
	dialog_scene.set_process_input(false)
	
	# Update the UI with the new scores
	update_ui()
	
	if "AmenagementCyclable" in PlayerData.event_occured:
		if PlayerData.map == "map1":
			$Map/Roads_cycles_and_bus.show()
			print("CYCLE")
		else:
			$Map/Roads_cycles_and_bus.hide()
			print("NO_CYCLE")
		if PlayerData.map == "map2":
			$Map2/Roads_cycles_and_bus.show()
			print("CYCLE")
		else:
			$Map2/Roads_cycles_and_bus.hide()
			print("NO_CYCLE")
		if PlayerData.map == "map3":
			$Map3/Roads_cycles_and_bus.show()
			print("CYCLE")
		else:
			$Map3/Roads_cycles_and_bus.hide()
			print("NO_CYCLE")
	# Save the game state
	save()

func _on_GuidOpenData_close_guide():
	if tuto_completed == true or can_use == "close_guide":
		if can_use == "close_guide":
			listen_state_data()

		state = State.STANDARD
		ui.show()
		$CanvasLayer/GuideOpenData.hide()

		# Enable the camera
		$Camera2D.block_camera(false)

func _on_EventResult_close_results():
	if tuto_completed == true or can_use == "close_result":
		if can_use == "close_result":
			listen_state_data()

		state = State.STANDARD
		
		# Show the ui and hide the results
		ui.show()
		$CanvasLayer/EventResult.hide()

		# Enable the camera
		$Camera2D.block_camera(false)
		
		timer_launched = false
		notif_scenar = false

func _on_No_Datapoints_close_no_datapoints():
	state = State.STANDARD
	
	# Show the ui and hide the results
	$CanvasLayer/No_Datapoints.hide()

	# Enable the camera
	$Camera2D.block_camera(false)

func _on_CityUI_closed_tutorial():
	# Enable the camera
	$Camera2D.block_camera(false)
	
	if tuto_completed == false:
		can_click = true

		city_shadow.set_deferred("visible", true)
		ui_shadow.set_deferred("visible", true)
		dialog_tuto.show()
		dialog_tuto_line.set_text("Bienvenue à ")
		dialog_tuto_line.add_text(PlayerData.city)
		dialog_tuto_line.add_text(", nous allons vous apprendre tout ce que vous devez savoir pour évoluer dans ce jeu !")

func save():
	if tuto_completed == true:
		# Save data
		var save_dict = {
			# Save data from PlayerData
			"building_list": PlayerData.building_list,
			"building_limit": PlayerData.building_limit,
			"bureau": PlayerData.bureau,
			"gender": PlayerData.gender,
			"event_occured": PlayerData.event_occured,
			"city_data": PlayerData.city_data,
			"data_points": PlayerData.data_points,
			"tuto_completed": tuto_completed,
			"city_name": PlayerData.city,
			"player_incomes": PlayerData.incomes,
			"map": PlayerData.map,
			# Currently waiting event
			"current_event": current_event,
			# Save the position of "can place" tiles, for restore them at destruction.
			"can_place_positions": PlayerData.can_place_position,
			# Grid of buildings

			"buildings": buildings_map.save_string(),
			"buildings2": buildings_map2.save_string(),
			"buildings3": buildings_map3.save_string(),
		}
		
		# Save 
		var save_game = File.new()
		save_game.open(PlayerData.SAVEFILE, File.WRITE)
		save_game.store_line(to_json(save_dict))
		
		# Close the file
		save_game.close()
		
		print("Saved !")

func load_save():
	# Open the save
	var file = File.new()
	var err = file.open(PlayerData.SAVEFILE, File.READ)
	
	# An error occured
	if err:
		return false
	
	# Check if all keys are in the save
	var dic = Dictionary(parse_json(file.get_line()))

	# Key list
	var keys = ["building_list","building_limit", "bureau","gender","event_occured",
	"city_data","data_points","city_name", "current_event","buildings","buildings2", "buildings3","tuto_completed", "player_incomes", "map", "can_place_positions"]
	
	# Check each key	
	for k in keys:
		if not k in dic.keys():
			return false
	# Try to load the buildings
	if PlayerData.map == "map1":
		if not buildings_map.load_string(dic["buildings"]):
			return false
	elif PlayerData.map == "map2":
		if not buildings_map2.load_string(dic["buildings2"]):
			return false
	elif PlayerData.map == "map3":
		if not buildings_map3.load_string(dic["buildings3"]):
			return false

	buildings_map.load_string(dic["buildings"])
	buildings_map2.load_string(dic["buildings2"])
	buildings_map3.load_string(dic["buildings3"])
	PlayerData.can_place_position = dic["can_place_positions"]

	PlayerData.building_limit = dic["building_limit"]
	PlayerData.bureau = dic["bureau"]
	PlayerData.gender = dic["gender"]
	PlayerData.city = dic["city_name"]
	PlayerData.building_list = dic["building_list"]
	PlayerData.event_occured = dic["event_occured"]
	PlayerData.city_data = dic["city_data"]
	PlayerData.data_points = dic["data_points"]
	PlayerData.map = dic["map"]
	PlayerData.tuto_advancement = dic["tuto_completed"]
	PlayerData.incomes = dic["player_incomes"]
	current_event = dic["current_event"]
	return true
# warning-ignore:unreachable_code

func open_no_datapoints():
	if state == State.STANDARD:
		$CanvasLayer/No_Datapoints.show()
		
		# Disable the camera
		$Camera2D.block_camera(true)

func update_preview():
	if PlayerData.map == "map1":
		buildings_map.show_constructible_tile(true)
		buildings_map.validation = false
	elif PlayerData.map == "map2":
		buildings_map2.show_constructible_tile(true)
		buildings_map2.validation = false
	elif PlayerData.map == "map3":
		buildings_map3.show_constructible_tile(true)
		buildings_map3.validation = false
	if PlayerData.map == "map1":
		$Map/Buildings/preview.show()
	elif PlayerData.map == "map2":
		$Map2/Buildings/preview.show()
	elif PlayerData.map == "map3":
		$Map3/Buildings/preview.show()
	buildings_map.set_preview_offset(building_name_to_place)
	buildings_map2.set_preview_offset(building_name_to_place)
	buildings_map3.set_preview_offset(building_name_to_place)
	if BuildingsData.SIZES[building_name_to_place] == Vector2(1,1):
		if PlayerData.map == "map1":
			$Map/Buildings/preview/preview_tile.show()
			$Map/Buildings/preview/preview_tile_2.hide()
			$Map/Buildings/preview/preview_tile_3.hide()
			$Map/Buildings/preview/preview_tile/building.show()
			$Map/Buildings/preview/preview_tile_2/building.hide()
			$Map/Buildings/preview/preview_tile_3/building.hide()
			$Map/Buildings/preview/preview_tile/building.texture = BuildingsData.TEXTURES[building_name_to_place]
		elif PlayerData.map == "map2":
			$Map2/Buildings/preview/preview_tile.show()
			$Map2/Buildings/preview/preview_tile_2.hide()
			$Map2/Buildings/preview/preview_tile_3.hide()
			$Map2/Buildings/preview/preview_tile/building.show()
			$Map2/Buildings/preview/preview_tile_2/building.hide()
			$Map2/Buildings/preview/preview_tile_3/building.hide()
			$Map2/Buildings/preview/preview_tile/building.texture = BuildingsData.TEXTURES[building_name_to_place]
		elif PlayerData.map == "map3":
			$Map3/Buildings/preview/preview_tile.show()
			$Map3/Buildings/preview/preview_tile_2.hide()
			$Map3/Buildings/preview/preview_tile_3.hide()
			$Map3/Buildings/preview/preview_tile/building.show()
			$Map3/Buildings/preview/preview_tile_2/building.hide()
			$Map3/Buildings/preview/preview_tile_3/building.hide()
			$Map3/Buildings/preview/preview_tile/building.texture = BuildingsData.TEXTURES[building_name_to_place]
	if BuildingsData.SIZES[building_name_to_place]  == Vector2(2,2):
		if PlayerData.map == "map1":
			$Map/Buildings/preview/preview_tile.hide()
			$Map/Buildings/preview/preview_tile_2.show()
			$Map/Buildings/preview/preview_tile_3.hide()
			$Map/Buildings/preview/preview_tile/building.hide()
			$Map/Buildings/preview/preview_tile_2/building.show()
			$Map/Buildings/preview/preview_tile_3/building.hide()
			$Map/Buildings/preview/preview_tile_2/building.texture = BuildingsData.TEXTURES[building_name_to_place]
		elif PlayerData.map == "map2":
			$Map2/Buildings/preview/preview_tile.hide()
			$Map2/Buildings/preview/preview_tile_2.show()
			$Map2/Buildings/preview/preview_tile_3.hide()
			$Map2/Buildings/preview/preview_tile/building.hide()
			$Map2/Buildings/preview/preview_tile_2/building.show()
			$Map2/Buildings/preview/preview_tile_3/building.hide()
			$Map2/Buildings/preview/preview_tile_2/building.texture = BuildingsData.TEXTURES[building_name_to_place]
		elif PlayerData.map == "map3":
			$Map3/Buildings/preview/preview_tile.hide()
			$Map3/Buildings/preview/preview_tile_2.show()
			$Map3/Buildings/preview/preview_tile_3.hide()
			$Map3/Buildings/preview/preview_tile/building.hide()
			$Map3/Buildings/preview/preview_tile_2/building.show()
			$Map3/Buildings/preview/preview_tile_3/building.hide()
			$Map3/Buildings/preview/preview_tile_2/building.texture = BuildingsData.TEXTURES[building_name_to_place]
	if BuildingsData.SIZES[building_name_to_place] == Vector2(3,3):
		if PlayerData.map == "map1":
			$Map/Buildings/preview/preview_tile.hide()
			$Map/Buildings/preview/preview_tile_2.hide()
			$Map/Buildings/preview/preview_tile_3.show()
			$Map/Buildings/preview/preview_tile/building.hide()
			$Map/Buildings/preview/preview_tile_2/building.hide()
			$Map/Buildings/preview/preview_tile_3/building.show()
			$Map/Buildings/preview/preview_tile_3/building.texture = BuildingsData.TEXTURES[building_name_to_place]
		elif PlayerData.map == "map2":
			$Map2/Buildings/preview/preview_tile.hide()
			$Map2/Buildings/preview/preview_tile_2.hide()
			$Map2/Buildings/preview/preview_tile_3.show()
			$Map2/Buildings/preview/preview_tile/building.hide()
			$Map2/Buildings/preview/preview_tile_2/building.hide()
			$Map2/Buildings/preview/preview_tile_3/building.show()
			$Map2/Buildings/preview/preview_tile_3/building.texture = BuildingsData.TEXTURES[building_name_to_place]
		elif PlayerData.map == "map3":
			$Map3/Buildings/preview/preview_tile.hide()
			$Map3/Buildings/preview/preview_tile_2.hide()
			$Map3/Buildings/preview/preview_tile_3.show()
			$Map3/Buildings/preview/preview_tile/building.hide()
			$Map3/Buildings/preview/preview_tile_2/building.hide()
			$Map3/Buildings/preview/preview_tile_3/building.show()
			$Map3/Buildings/preview/preview_tile_3/building.texture = BuildingsData.TEXTURES[building_name_to_place]

func listen_state_data():

	current_tuto = next_tuto
	set_next_tuto()
	can_click = false
	can_use = "not_defined"
	
	match current_tuto:
		State_tuto.BUILDING_BUTTON:
			print("BUILDING_BUTTON")
			dialog_tuto.rect_position = Vector2(830, 320)
			building_button.material.set_light_mode(1)
			$CanvasLayer/CityUI/AnimationPlayer.play("scale_anim_build")
			dialog_tuto_line.set_text("Pour commencer, tentons de construire via le")
#			dialog_tuto_line.push_color(Default: )
			print(dialog_tuto_line.push_color(Color.red))
			dialog_tuto_line.add_text(" menu de construction.")
			yield(get_tree().create_timer(0.5), "timeout")
			build_menu.scrolling(false)
			can_use = "building_button"
			
		State_tuto.INFO_BUILDING:
			print("INFO_BUTTON")
			dialog_tuto.rect_position = Vector2(182, 265)
			build_shadow.set_deferred("visible", true)
			dialog_tuto_line.set_text("Dans ce menu, vous pouvez voir les bâtiments qu'il vous est possible de construire dans votre ville.")
			building_button.material.set_light_mode(0)
			building_card_build.material.set_light_mode(1)
			building_card_build_sprite.material.set_light_mode(1)
			building_button.rect_scale = Vector2(1,1)
			building_button.rect_position = Vector2(0,0)
			$CanvasLayer/CityUI/AnimationPlayer.stop()
			yield(get_tree().create_timer(0.5), "timeout")
			can_click = true

		State_tuto.INFO_BUILDING_2:
			print("INFO_BUILDING_2")
			$CanvasLayer/tuto_aff/tuto_infos_building.show()
			dialog_tuto_line.set_text("Certains bâtiments possèdent des")
			dialog_tuto_line.push_color(Color.green)
			dialog_tuto_line.add_text(" bonus.")
			yield(get_tree().create_timer(0.5), "timeout")
			can_click = true
		
		State_tuto.INFO_BUILDING_3:
			dialog_tuto_line.set_text("Chaque bâtiment")
			dialog_tuto_line.push_color(Color.red)
			dialog_tuto_line.add_text(" coûte des Data Points")
			dialog_tuto_line.push_color(Color.orange)
			dialog_tuto_line.add_text(" et ne peut être construit")
			dialog_tuto_line.push_color(Color.blue)
			dialog_tuto_line.add_text(" qu'un certain nombre de fois.")
			yield(get_tree().create_timer(0.5), "timeout")
			can_click = true
		
		State_tuto.INFO_BUILDING_LAST:
			$CanvasLayer/tuto_aff/tuto_infos_building.hide()
			dialog_tuto_line.set_text("Maintenant, tentez de sélectionner un bâtiment en cliquant dessus.")
			yield(get_tree().create_timer(0.5), "timeout")
			can_use = "select_building"
		
		State_tuto.BUILDING_POSE:
			$CanvasLayer/tuto_aff/tuto_infos_building.hide()
			dialog_tuto.rect_position = Vector2(492, 280)
			$CanvasLayer/place_building_tuto.show()
#			dialog_tuto_line.set_text("Cliquez sur un emplacement libre pour poser votre bâtiment.")
			city_shadow.set_deferred("visible", false)
			dialog_tuto.hide()
			yield(get_tree().create_timer(0.5), "timeout")
			can_use = "pose_building"
		
		State_tuto.INFOS_UI:
			$CanvasLayer/place_building_tuto.hide()
			dialog_tuto.set_deferred("visible", true)
			$CanvasLayer/tuto_aff/tuto_points.rect_position = Vector2(321, 563)
			$CanvasLayer/tuto_aff/tuto_points.rect_size = Vector2(220,46)
			$CanvasLayer/tuto_aff/tuto_points.show()
			
			build_shadow.set_deferred("visible", false)
			building_card_build.material.set_light_mode(0)
			building_card_build_sprite.material.set_light_mode(0)
			city_shadow.set_deferred("visible", true)
			dialog_tuto.rect_position = Vector2(372, 400)
			dialog_tuto_line.set_text("Ici, vous pouvez voir que le prix du bâtiment construit, à été déduit de vos")
			dialog_tuto_line.push_color(Color.red)
			dialog_tuto_line.add_text(" Data Points.")
			build_menu.scrolling(true)
			yield(get_tree().create_timer(0.5), "timeout")
			can_click = true

		State_tuto.INCOMES:
			$CanvasLayer/tuto_aff/tuto_points.rect_position = Vector2(459, 563)
			$CanvasLayer/tuto_aff/tuto_points.rect_size = Vector2(82,46)
			$CanvasLayer/dialog_tuto/text/DialogLine.rect_size = Vector2(416, 149)
			$CanvasLayer/tuto_aff/tuto_points.show()
			$CanvasLayer/dialog_tuto/text/DialogLine.rect_size = Vector2(350, 209)
			$CanvasLayer/dialog_tuto/text.rect_size = Vector2(473, 208)
			dialog_tuto_line.set_text("Ici, vous pouvez voir vos")
			dialog_tuto_line.push_color(Color.red)
			dialog_tuto_line.add_text(" revenus,")
			dialog_tuto_line.push_color(Color.orange)
			dialog_tuto_line.add_text(" il s'agit du nombre de Data Points que vous gagnez grâce à chaque seconde que vous passez dans le jeu.")
			yield(get_tree().create_timer(0.5), "timeout")
			can_click = true

		State_tuto.INFOS_UI_2:
			$CanvasLayer/dialog_tuto/text.rect_size = Vector2(342, 192)
			$CanvasLayer/dialog_tuto/text/DialogLine.rect_size = Vector2(330, 149)
			$CanvasLayer/tuto_aff/tuto_points.hide()
			$CanvasLayer/tuto_aff/tuto_pop.show()
			dialog_tuto.rect_position = Vector2(370, 420)
			dialog_tuto_line.set_text("Ici, vous pouvez voir que le bâtiment que vous venez de construire a augmenté votre")
			dialog_tuto_line.push_color(Color.green)
			dialog_tuto_line.add_text(" population max.")
			yield(get_tree().create_timer(0.5), "timeout")
			can_click = true

		State_tuto.INFOS_UI_LAST:
			$CanvasLayer/tuto_aff/tuto_pop.hide()
			$CanvasLayer/tuto_aff/tuto_satisfaction.show()
			dialog_tuto.rect_position = Vector2(149, 117)
			dialog_tuto_line.set_text("Ici, vous pouvez voir la")
			dialog_tuto_line.push_color(Color.blue)
			dialog_tuto_line.add_text(" satisfaction")
			dialog_tuto_line.push_color(Color.orange)
			dialog_tuto_line.add_text(" de vos citoyens.")
			yield(get_tree().create_timer(0.5), "timeout")
			can_click = true

		State_tuto.INFOS_EVENT:
			print("INFOS_EVENT:")
			$CanvasLayer/tuto_aff/tuto_satisfaction.hide()
			dialog_tuto.rect_position = Vector2(492, 280)
			dialog_tuto_line.set_text("En construisant vos bâtiments, des")
			dialog_tuto_line.push_color(Color.darkmagenta)
			dialog_tuto_line.add_text(" évènements")
			dialog_tuto_line.push_color(Color.orange)
			dialog_tuto_line.add_text(" peuvent se déclencher.")
			yield(get_tree().create_timer(0.5), "timeout")
			can_click = true

		State_tuto.EVENT_BUTTON:
		#ui.display_notification()
			print("EVENT_BUTTON")
			dialog_tuto.rect_position = Vector2(492, 208)
			dialog_tuto_line.set_text("Une")
			dialog_tuto_line.push_color(Color.darkmagenta)
			dialog_tuto_line.add_text(" notification")
			dialog_tuto_line.push_color(Color.orange)
			dialog_tuto_line.add_text(" s'affiche alors, appuyez sur le bouton pour lancer l'évènement.")
			$CanvasLayer/CityUI/AnimationPlayer.play("scale_anim_event")
			yield(get_tree().create_timer(0.5), "timeout")
			can_use = "event_button"
		
		State_tuto.EVENT_LAUNCHED:
			$CanvasLayer/CityUI/AnimationPlayer.stop()
			dialog_tuto.hide()
		
		State_tuto.EVENT_FINISH:
			dialog_tuto.show()
			dialog_tuto.rect_position = Vector2(165, 275)
			dialog_tuto_line.set_text("À la fin de chaque évènement, vous verrez vos gains ou vos pertes.")
			yield(get_tree().create_timer(0.5), "timeout")
			can_click = true
		
		State_tuto.INFOS_RESULT:
			$CanvasLayer/tuto_aff/tuto_infos_result.show()
			dialog_tuto_line.set_text("Vous pourrez obtenir")
			dialog_tuto_line.push_color(Color.red)
			dialog_tuto_line.add_text(" des points de satisfaction ou des Data Points.")
			yield(get_tree().create_timer(0.5), "timeout")
			can_click = true
		
		State_tuto.INFOS_RESULT_2:
			dialog_tuto_line.set_text("Vous pourrez aussi obtenir")
			dialog_tuto_line.push_color(Color.green)
			dialog_tuto_line.add_text(" des bâtiments")
			dialog_tuto_line.push_color(Color.orange)
			dialog_tuto_line.add_text(", pouvant être construits après l'évènement.")
			yield(get_tree().create_timer(0.5), "timeout")
			can_click = true
		
		State_tuto.INFOS_RESULT_LAST:
			dialog_tuto.rect_position = Vector2(796, 280)
			$CanvasLayer/tuto_aff/tuto_infos_result.hide()
			dialog_tuto_line.set_text("Cliquez sur la croix, afin de revenir sur l'écran de gestion de votre ville.")
			yield(get_tree().create_timer(0.5), "timeout")
			can_use = "close_result"
		
		State_tuto.GUIDE_TUTO:
			$CanvasLayer/CityUI/AnimationPlayer.play("scale_anim_guide")
			dialog_tuto.rect_position = Vector2(830, 200)
			guide_button.material.set_light_mode(1)
			dialog_tuto_line.set_text("Vous pouvez également consulter le guide de l'Opendata, juste ici.")
			yield(get_tree().create_timer(2), "timeout")
			can_use = "guide"
		
		State_tuto.GUIDE_OPENED:
			$CanvasLayer/CityUI/AnimationPlayer.stop()
			guide_button.material.set_light_mode(0)
			dialog_tuto.hide()
			yield(get_tree().create_timer(2), "timeout")
			can_use = "close_guide"
		
		State_tuto.LAST_TUTO:
			dialog_tuto.show()
			dialog_tuto.rect_position = Vector2(492, 280)
			dialog_tuto_line.set_text("Félicitations, je n'ai plus rien à vous apprendre, à part peut-être sur l'Open Data !")
			yield(get_tree().create_timer(0.5), "timeout")
			can_click = true
		
		State_tuto.TUTO_FINISHED:
			ui_shadow.set_deferred("visible", false)
			city_shadow.set_deferred("visible", false)
			dialog_tuto.set_deferred("visible", false)
			tuto_completed = true
			save()

func set_next_tuto():
	match current_tuto:
		State_tuto.BUILDING_BUTTON:
			next_tuto = State_tuto.INFO_BUILDING
		State_tuto.INFO_BUILDING:
			next_tuto = State_tuto.INFO_BUILDING_2
		State_tuto.INFO_BUILDING_2:
			next_tuto = State_tuto.INFO_BUILDING_3
		State_tuto.INFO_BUILDING_3:
			next_tuto = State_tuto.INFO_BUILDING_LAST
		State_tuto.INFO_BUILDING_LAST:
			next_tuto = State_tuto.BUILDING_POSE
		State_tuto.BUILDING_POSE:
			next_tuto = State_tuto.INFOS_UI
		State_tuto.INFOS_UI:
			next_tuto = State_tuto.INCOMES
		State_tuto.INCOMES:
			next_tuto = State_tuto.INFOS_UI_2
		State_tuto.INFOS_UI_2:
			next_tuto = State_tuto.INFOS_UI_LAST
		State_tuto.INFOS_UI_LAST:
			next_tuto = State_tuto.INFOS_EVENT
		State_tuto.INFOS_EVENT:
			next_tuto = State_tuto.EVENT_BUTTON
		State_tuto.EVENT_BUTTON:
			next_tuto = State_tuto.EVENT_LAUNCHED
		State_tuto.EVENT_LAUNCHED:
			next_tuto = State_tuto.EVENT_FINISH
		State_tuto.EVENT_FINISH:
			next_tuto = State_tuto.INFOS_RESULT
		State_tuto.INFOS_RESULT:
			next_tuto = State_tuto.INFOS_RESULT_2
		State_tuto.INFOS_RESULT_2:
			next_tuto = State_tuto.INFOS_RESULT_LAST
		State_tuto.INFOS_RESULT_LAST:
			next_tuto = State_tuto.GUIDE_TUTO
		State_tuto.GUIDE_TUTO:
			next_tuto = State_tuto.GUIDE_OPENED
		State_tuto.GUIDE_OPENED:
			next_tuto = State_tuto.LAST_TUTO
		State_tuto.LAST_TUTO:
			next_tuto = State_tuto.TUTO_FINISHED
	print("CHANGE_STATE_TUTO")

func _input(event):
	if can_click == true:
		if event is InputEventScreenTouch or event is InputEventMouseButton:
			listen_state_data()


func _on_ScenaristicTimer_timeout():
	if notif_scenar == false && timer_launched == true:
		notif_scenar = true
		trigger_scenaristic_event()


func _on_CityUI_cancel_hover():
	cancel_hovered = true


func _on_CityUI_destroy_button_pressed():
	if tuto_completed == true and destruction_launched == false and build_opened == false:
		#Change State to choosing place
		state = State.CHOOSING_PLACE
		destruction_launched = true
		build_menu.hide()
		destroy_button.hide()
		ui.show_cancel_button()


func _on_CityUI_stop_cancel_hover():
	cancel_hovered = false


func _on_CityUI_validate_destruction():
	destruction()
	$Camera2D.block_camera(false)


func _on_Incomes_timeout():
	PlayerData.data_points += PlayerData.incomes
	ui.set_datapoints(PlayerData.data_points)
