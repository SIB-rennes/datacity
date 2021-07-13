extends Node
class_name BuildingsData

# The Building Tileset
const BUILDINGS = preload("res://tilesets/buildings.tres")


# Dictionnary of building sizes (case occupied)
# The buildings should always be placed at the lower case
# (x, y) : x to the top left, y to the top right
const SIZES = {
	"GrandCafe": Vector2(1, 2),
	"Commissariat": Vector2(2, 1),
	"GrandCommissariat": Vector2(2, 1),
	"GrandeEcole": Vector2(1, 2),
	"GrandHopital": Vector2(2, 2),
	"Hopital": Vector2(1, 2),
	"Mairie": Vector2(2, 1),
	"Musee": Vector2(2, 1),
	"Parc": Vector2(2, 2),
	"Restaurant": Vector2(2, 1),
	"Ecole": Vector2(1, 2),
}

# Preload all textures
const TEXTURES = {
	"Batiment": preload("res://assets/sprites/buildings/batiment.png"),
	"Cafe": preload("res://assets/sprites/buildings/cafe.png"),
	"GrandCafe": preload("res://assets/sprites/buildings/cafe2.png"),
	"Commissariat": preload("res://assets/sprites/buildings/commissariat.png"),
	"GrandCommissariat": preload("res://assets/sprites/buildings/grandcommissariat.png"),
	"GrandeEcole": preload("res://assets/sprites/buildings/grandeecole.png"),
	"GrandHopital": preload("res://assets/sprites/buildings/grandhopital.png"),
	"Mairie": preload("res://assets/sprites/buildings/mairiegauche.png"),
	"Hopital": preload("res://assets/sprites/buildings/hopital.png"),
	"Maison1": preload("res://assets/sprites/buildings/maison1droite.png"),
	"Maison2": preload("res://assets/sprites/buildings/maison2droite.png"),
	"Maison3": preload("res://assets/sprites/buildings/maison3gauche.png"),
	"Musee": preload("res://assets/sprites/buildings/musee.png"),
	"Parc": preload("res://assets/sprites/buildings/parcdroit.png"),
	"Pharmacie": preload("res://assets/sprites/buildings/pharmacie.png"),
	"Restaurant": preload("res://assets/sprites/buildings/restaurantgauche.png"),
	"Ecole": preload("res://assets/sprites/buildings/school.png"),
	"Theatre": preload("res://assets/sprites/buildings/theatre.png")
}

# The increase in max popuation for each building
const POPULATION_SPACE = {
	"Mairie": 10,
	"Maison 1": 10,
	"Maison 2": 15,
	"Maison 3": 20
}



# Default building size
const DEFAULT_SIZE = Vector2.ONE


static func get_size(building_index):
	# Get the building name
	var building_name = BUILDINGS.tile_get_name(building_index)
	
	return SIZES.get(building_name, DEFAULT_SIZE)

