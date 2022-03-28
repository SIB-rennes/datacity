extends Node
class_name BuildingsData

# The Building Tileset
const BUILDINGS = preload("res://tilesets/buildings.tres")


# Dictionnary of building sizes (case occupied)
# The main case of a building should always be the bottom case
# (x, y) : x to the top left, y to the top right
const SIZES = {
	"Office de tourisme": Vector2(1,1),
	"Etablissement de santé": Vector2(1,1),
	"Maison 1": Vector2(1,1),
	"Grande maison": Vector2(2,2),
	"Maison 3": Vector2(1,1),
	"Supérette": Vector2(1,1),
	"Grand Cafe": Vector2(1, 2),
	"Commissariat": Vector2(1, 1),
	"Grand Commissariat": Vector2(2, 1),
	"Grande Ecole": Vector2(2, 2),
	"Grand Hôpital": Vector2(2, 2),
	"Hopital": Vector2(2, 2),
	"Mairie": Vector2(2, 2),
	"Musee": Vector2(2, 2),
	"Parc": Vector2(2, 2),
	"Supermarché": Vector2(3, 3),
	"Ecole": Vector2(2, 2),
	"Centre Associatif": Vector2(2,2),
	"Complexe Sportif": Vector2(2,2),
	"Immeuble": Vector2(2,2),
	"Caserne": Vector2(2,2),
	"Theatre": Vector2(2,2),
	"Déchetterie": Vector2(3,3)
}

const INCOMES = {
	"Supérette": 1,
	"Supermarché": 5,
}
#Tex OFFSET value for preview in Buildings.gd
const OFFSET = {
	"Etablissement de santé": Vector2(0, -88.023),
	"Office de tourisme": Vector2(-0.707,-77.886),
	"Immeuble": Vector2(-265.922,-110.165),
	"Maison 1": Vector2(0,-91.457),
	"Grande maison": Vector2(-258.268,-73.563),
	"Maison 3": Vector2(0.933,-31.09),
	"Supérette": Vector2(0.559,-44.763),
	"Grand Cafe": Vector2(1, 2),
	"Commissariat": Vector2(0, -102.688),
	"Grand Commissariat": Vector2(2, 1),
	"Grande Ecole": Vector2(2, 1),
	"Grand Hôpital": Vector2(2, 2),
	"Hopital": Vector2(1, 2),
	"Mairie": Vector2(-244.353, -141.372),
	"Musee": Vector2(-264.952, -22.964),
	"Parc": Vector2(2, 2),
	"Supermarché": Vector2(0, -120),
	"Ecole": Vector2(-265.944, -122.669),
	"Centre Associatif": Vector2(-262.54,-19.197),
	"Complexe Sportif": Vector2(-264.27,-59.601),
	"Caserne": Vector2(-263.807,-19.366),
	"Déchetterie": Vector2(0,0),
	"Theatre": Vector2(-262.66,-230.328)
}

# Preload all textures
const TEXTURES = {
	"Complexe Sportif": preload("res://assets/sprites/buildings/complexe_sportif.png"),
	"Office de tourisme": preload("res://assets/sprites/buildings/office_de_tourisme.svg"),
	"Etablissement de santé": preload("res://assets/sprites/buildings/cabinet.svg"),
	"Supérette": preload("res://assets/sprites/buildings/superette.svg"),
	"Grand Cafe": preload("res://assets/sprites/buildings/cafe2.png"),
	"Commissariat": preload("res://assets/sprites/buildings/commissariat.png"),
	"Grand Commissariat": preload("res://assets/sprites/buildings/grandcommissariat.png"),
	"Grande Ecole": preload("res://assets/sprites/buildings/grandeecole.png"),
	"Grand Hôpital": preload("res://assets/sprites/buildings/grandhopital.png"),
	"Mairie": preload("res://assets/sprites/buildings/mairiegauche.png"),
	"Hopital": preload("res://assets/sprites/buildings/hopital.png"),
	"Maison 1": preload("res://assets/sprites/buildings/maison_1.svg"),
	"Grande maison": preload("res://assets/sprites/buildings/grande_maison.png"),
	"Maison 3": preload("res://assets/sprites/buildings/petite_maison.png"),
	"Immeuble": preload("res://assets/sprites/buildings/immeuble.svg"),
	"Musee": preload("res://assets/sprites/buildings/musee.png"),
	"Parc": preload("res://assets/sprites/buildings/parcdroit.png"),
	"Supermarché": preload("res://assets/sprites/buildings/supermarche.png"),
	"Ecole": preload("res://assets/sprites/buildings/Ecole.svg"),
	"Theatre": preload("res://assets/sprites/buildings/theatre.png"),
	"Centre Associatif": preload("res://assets/sprites/buildings/centre_asso.png"),
	"Caserne": preload("res://assets/sprites/buildings/caserne.png"),
	"Déchetterie": preload("res://assets/sprites/buildings/dechetterie.png")
}

# The increase in max popuation for each building
const POPULATION_SPACE = {
	"Maison 1": 20,
	"Grande maison": 30,
	"Maison 3": 10,
	"Immeuble": 80
}

# The increase in Satisfaction for each building
const SATISFACTION_POINTS = {
	"Complexe Sportif": 50,
	"Caserne": 50,
	"Office de tourisme": 30,
	"Etablissement de santé": 30,
	"Hopital": 30,
	"Grand Hôpital": 30,
	"Commissariat": 20,
	"Grand Commissariat": 30,
	"Grande Ecole": 20,
	"Musee": 50,
	"Parc": 20,
	"Ecole": 30,
	"Theatre": 20,
	"Centre Associatif": 20,
	"Déchetterie": 50,
}

# Buildings given every time the *population* gets to a certain level
const BUILDINGS_FROM_POP = {
	"Maison 1": 50,
	"Grande maison": 30,
	"Maison 3": 30,
	"Immeuble": 100,
}

# Buildings given every time the *MAX population* gets to a certain level
const BUILDINGS_FROM_MAX_POP = {
}

const PRIX = {
	"Complexe Sportif": 50,
	"Office de tourisme": 30,
	"Etablissement de santé": 25,
	"Maison 1": 25,
	"Grande maison": 100,
	"Maison 3": 25,
	"Immeuble": 50,
	"Mairie": 0,
	"Supérette":50,
	"Grand Cafe": 20,
	"Commissariat": 25,
	"Grande Ecole": 25,
	"Grand Commissariat": 15,
	"Grand Hôpital": 15,
	"Hopital": 10,
	"Musee": 50,
	"Parc": 5,
	"Supermarché": 200,
	"Ecole": 25,
	"Theatre": 50,
	"Centre Associatif": 150,
	"Caserne": 25,
	"Déchetterie": 50
	
}

const ADMIN = {
	"Commissariat": 1,
	"Grand Commissariat": 1,
	"Grande Ecole": 1,
}
const ASSOCIATIF = {
	"Centre Associatif": 1
}

const COMMERCIAL = {
	"Supérette": 1,
	"Grand Cafe": 1,
	"Supermarché": 1,
}

const HABITATION = {
	"Maison 1": 1,
	"Grande maison": 1,
	"Maison 3": 1,
	"Immeuble": 1,
	"Ecole": 1,
}

const LOISIR = {
	"Complexe Sportif": 1,
	"Office de tourisme": 1,
	"Musee": 1,
	"Parc": 1,
	"Theatre": 1
}

const SANTE = {
	"Etablissement de santé": 1,
	"Hopital": 1,
	"Grand Hôpital": 1,
}

const MEDIUM_BUILDING = {
	"Ecole": 1,
	"Centre Associatif": 1,
	"Complexe Sportif": 1,
	"Grande maison":1,
	"Immeuble": 1,
	"Caserne": 1,
}

const BIG_BUILDING = {
	"Supermarché": 1,
}

static func recover_money(building: String):
	PlayerData.data_points += PRIX[building]

static func recover_incomes(building: String):
	if building in INCOMES:
		PlayerData.incomes -= INCOMES[building]
	else:
		print("Nope")

static func building_incomes(building: String):
	if building in INCOMES:
		PlayerData.incomes += INCOMES[building]

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
	#incomes
	elif building in INCOMES:
		res = [PlayerData.INCOMES,INCOMES[building]]

	return res
