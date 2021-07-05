extends Node2D

# References to the Road and Building tilemaps
onready var roads = $Roads
onready var buildings = $Buildings


signal clicked_map(case_index, case_center_coords)


func _ready():
	# Get the positions of the roads
	var road_positions = roads.get_used_cells()
	
	# The "occupied" cell
	var occupied_val = buildings.tile_set.find_tile_by_name("Occupied")
	
	for pos in road_positions:
		buildings.set_cellv(pos, occupied_val)



func _process(delta):
	if Input.is_action_just_pressed("MouseClic"):
			process_player_click(get_global_mouse_position())



func process_player_click(position):
	# Get the case on the building tilemap
	var case_index = buildings.world_to_map(position)
	var case_center = buildings.map_to_world(case_index)
	
	emit_signal("clicked_map", case_index, case_center)
	print("Clicked " + String(case_index))
