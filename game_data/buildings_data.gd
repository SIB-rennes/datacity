extends Node
class_name BuildingsData

# The Building Tileset
const BUILDINGS = preload("res://tilesets/buildings.tres")


# Dictionnary of building sizes (case occupied)
# The buildings should always be placed at the lower case
# (x, y) : x to the top left, y to the top right
const SIZES = {
	"Grand Cafe": Vector2(1, 2),
	"Commissariat": Vector2(2, 1),
	"Grand Commissariat": Vector2(2, 1),
	"Grande Ecole": Vector2(2, 1),
	"Grand Hopital": Vector2(2, 2),
	"Hopital": Vector2(1, 2),
	"Mairie": Vector2(2, 1),
	"Musee": Vector2(2, 1),
	"Parc": Vector2(2, 2),
	"Restaurant": Vector2(2, 1),
	"Ecole": Vector2(1, 2),
}

# Preload all textures
const TEXTURES = {
	"Cafe": preload("res://assets/sprites/buildings/cafe.png"),
	"Grand Cafe": preload("res://assets/sprites/buildings/cafe2.png"),
	"Commissariat": preload("res://assets/sprites/buildings/commissariat.png"),
	"Grand Commissariat": preload("res://assets/sprites/buildings/grandcommissariat.png"),
	"Grande Ecole": preload("res://assets/sprites/buildings/grandeecole.png"),
	"Grand Hopital": preload("res://assets/sprites/buildings/grandhopital.png"),
	"Mairie": preload("res://assets/sprites/buildings/mairiegauche.png"),
	"Hopital": preload("res://assets/sprites/buildings/hopital.png"),
	"Maison1": preload("res://assets/sprites/buildings/maison1droite.png"),
	"Maison2": preload("res://assets/sprites/buildings/maison2droite.png"),
	"Maison3": preload("res://assets/sprites/buildings/maison3gauche.png"),
	"Immeuble": preload("res://assets/sprites/buildings/batiment.png"),
	"Musee": preload("res://assets/sprites/buildings/musee.png"),
	"Parc": preload("res://assets/sprites/buildings/parcdroit.png"),
	"Pharmacie": preload("res://assets/sprites/buildings/pharmacie.png"),
	"Restaurant": preload("res://assets/sprites/buildings/restaurantgauche.png"),
	"Ecole": preload("res://assets/sprites/buildings/school.png"),
	"Theatre": preload("res://assets/sprites/buildings/theatre.png")
}

# The increase in max popuation for each building
const POPULATION_SPACE = {
	"Maison1": 10,
	"Maison2": 15,
	"Maison3": 25,
	"Immeuble": 80
}

# The increase in Sante for each building
const SANTE_POINTS = {
	"Pharmacie": 50,
	"Hopital": 100,
	"Grand Hopital": 250,
}

# The increase in Education for each building
const EDUCATION_POINTS = {
	"Ecole": 200,
	"Grande Ecole": 400,
}

# The increase in Loisirs for each building
const LOISIRS_POINTS = {
	"Cafe": 50,
	"Grand Cafe": 100,
	"Theatre": 100,
	"Parc": 100,
	"Restaurant": 250,
	"Musee": 250,
}

# The increase in Securite for each building
const SECURITE_POINTS = {
	"Commissariat": 250,
	"Grand Commissariat": 600,
}



# Buildings given every time the *population* gets to a certain level
const BUILDINGS_FROM_POP = {
	"Maison 1": 20,
	"Maison 2": 30,
	"Maison 3": 50,
	"Immeuble": 100,
}

# Buildings given every time the *MAX population* gets to a certain level
const BUILDINGS_FROM_MAX_POP = {
	"Pharmacie": 50,
	"Hopital": 100,
	
	"Ecole": 140,
	
	"Cafe": 50,
	"Grand Cafe": 100,
	"Parc": 200,
	"Theatre": 300,
	
	"Commissariat": 180
}



# Default building size
const DEFAULT_SIZE = Vector2.ONE


static func get_size(building_index):
	# Get the building name
	var building_name = BUILDINGS.tile_get_name(building_index)
	
	return SIZES.get(building_name, DEFAULT_SIZE)


# Returns a pair [category, value]
static func get_building_bonus(building: String):
	var res = ["", -1]
	
	# Max Population
	if building in POPULATION_SPACE:
		res = [PlayerData.POPULATION_MAX, POPULATION_SPACE[building]]
	# Sante
	elif building in SANTE_POINTS:
		res = [PlayerData.SANTE, SANTE_POINTS[building]]
	# Education
	elif building in EDUCATION_POINTS:
		res = [PlayerData.EDUCATION, EDUCATION_POINTS[building]]
	# Loisirs
	elif building in LOISIRS_POINTS:
		res = [PlayerData.LOISIRS, LOISIRS_POINTS[building]]
	# Securite
	elif building in SECURITE_POINTS:
		res = [PlayerData.SECURITE, SECURITE_POINTS[building]]
	
	return res
