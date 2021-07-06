extends Node
class_name BuildingsData

# The Building Tileset
const BUILDINGS = preload("res://tilesets/buildings.tres")


# Dictionnary of building sizes (case occupied)
# The buildings should always be placed at the lower case
const SIZES = {
	"PoliceDepartment": Vector2(2, 1),
	"Hospital": Vector2(1, 2)
}

# Default building size
const DEFAULT_SIZE = Vector2.ONE


static func get_size(building_index):
	# Get the building name
	var building_name = BUILDINGS.tile_get_name(building_index)
	
	return SIZES.get(building_name, DEFAULT_SIZE)

