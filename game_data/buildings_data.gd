extends Node
class_name BuildingsData

# The Building Tileset
const BUILDINGS = preload("res://tilesets/buildings.tres")


# Dictionnary of building sizes (case occupied)
# The main case of a building should always be the bottom case
# (x, y) : x to the top left, y to the top right
const SIZES = {
	"Grand Cafe": Vector2(1, 2),
	"Commissariat": Vector2(2, 1),
	"Grand Commissariat": Vector2(2, 1),
	"Grande Ecole": Vector2(2, 1),
	"Grand Hôpital": Vector2(2, 2),
	"Hopital": Vector2(1, 2),
	"Mairie": Vector2(2, 2),
	"Musee": Vector2(2, 1),
	"Parc": Vector2(2, 2),
	"Supermarche": Vector2(2, 3),
	"Ecole": Vector2(1, 2),
	"Centre Associatif": Vector2(2,2)
}

# Preload all textures
const TEXTURES = {
	"Cafe": preload("res://assets/sprites/buildings/cafe.png"),
	"Grand Cafe": preload("res://assets/sprites/buildings/cafe2.png"),
	"Commissariat": preload("res://assets/sprites/buildings/commissariat.png"),
	"Grand Commissariat": preload("res://assets/sprites/buildings/grandcommissariat.png"),
	"Grande Ecole": preload("res://assets/sprites/buildings/grandeecole.png"),
	"Grand Hôpital": preload("res://assets/sprites/buildings/grandhopital.png"),
	"Mairie": preload("res://assets/sprites/buildings/mairiegauche.png"),
	"Hopital": preload("res://assets/sprites/buildings/hopital.png"),
	"Maison 1": preload("res://assets/sprites/buildings/maison1droite.png"),
	"Maison 2": preload("res://assets/sprites/buildings/maison2droite.png"),
	"Maison 3": preload("res://assets/sprites/buildings/maison3gauche.png"),
	"Immeuble": preload("res://assets/sprites/buildings/batiment.png"),
	"Musee": preload("res://assets/sprites/buildings/musee.png"),
	"Parc": preload("res://assets/sprites/buildings/parcdroit.png"),
	"Pharmacie": preload("res://assets/sprites/buildings/pharmacie.png"),
	"Supermarche": preload("res://assets/sprites/buildings/restaurantgauche.png"),
	"Ecole": preload("res://assets/sprites/buildings/school.png"),
	"Theatre": preload("res://assets/sprites/buildings/theatre.png"),
	"Centre Associatif": preload("res://assets/sprites/buildings/centre_asso.png")
}

# The increase in max popuation for each building
const POPULATION_SPACE = {
	"Maison 1": 20,
	"Maison 2": 10,
	"Maison 3": 10,
	"Immeuble": 80
}

# The increase in Satisfaction for each building
const SATISFACTION_POINTS = {
	"Pharmacie": 30,
	"Hopital": 30,
	"Grand Hôpital": 30,
	"Cafe": 30,
	"Grand Cafe": 20,
	"Commissariat": 20,
	"Grand Commissariat": 30,
	"Grande Ecole": 20,
	"Musee": 50,
	"Parc": 20,
	"Supermarche": 20,
	"Ecole": 30,
	"Theatre": 20,
	"Centre Associatif": 20
}

# Buildings given every time the *population* gets to a certain level
const BUILDINGS_FROM_POP = {
	"Maison 1": 50,
	"Maison 2": 30,
	"Maison 3": 30,
	"Immeuble": 100,
}

# Buildings given every time the *MAX population* gets to a certain level
const BUILDINGS_FROM_MAX_POP = {
	"Cafe":70,
}

const PRIX = {
	"Maison 1": 10,
	"Maison 2": 10,
	"Maison 3": 10,
	"Immeuble": 50,
	"Mairie": 0,
	"Cafe":10,
	"Grand Cafe": 20,
	"Commissariat": 10,
	"Grande Ecole": 10,
	"Grand Commissariat": 15,
	"Grand Hôpital": 15,
	"Hopital": 10,
	"Musee": 20,
	"Parc": 5,
	"Pharmacie": 5,
	"Supermarche": 5,
	"Ecole": 5,
	"Theatre": 10,
	"Centre Associatif": 20
}

static func buildings_price(building: String):
	PlayerData.data_points -= PRIX[building]

static func get_buildings_price(building: String):
	var buildings_price = PRIX[building]

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
	# Satisfaction
	elif building in SATISFACTION_POINTS:
		res = [PlayerData.SATISFACTION,SATISFACTION_POINTS[building]]

	return res
