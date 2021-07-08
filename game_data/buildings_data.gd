extends Node
class_name BuildingsData

# The Building Tileset
const BUILDINGS = preload("res://tilesets/buildings.tres")


# Dictionnary of building sizes (case occupied)
# The buildings should always be placed at the lower case
const SIZES = {
	"Commissariat": Vector2(2, 1),
	"Hôpital": Vector2(1, 2)
}

# Preload all textures
const TEXTURES = {
	"Maison 1": preload("res://assets/sprites/buildings/house_1.png"),
	"Maison 2": preload("res://assets/sprites/buildings/house_2.png"),
	"Maison 3": preload("res://assets/sprites/buildings/house_3.png"),
	"Mairie": preload("res://assets/sprites/buildings/city_hall.png"),
	"Hôpital": preload("res://assets/sprites/buildings/hospital.png"),
	"Commissariat": preload("res://assets/sprites/buildings/police_department.png")
}



# Default building size
const DEFAULT_SIZE = Vector2.ONE


static func get_size(building_index):
	# Get the building name
	var building_name = BUILDINGS.tile_get_name(building_index)
	
	return SIZES.get(building_name, DEFAULT_SIZE)

