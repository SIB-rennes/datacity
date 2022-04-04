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
	"Maison 2": Vector2(1,1),
	"Grande maison": Vector2(2,2),
	"Maison 3": Vector2(1,1),
	"Supérette": Vector2(1,1),
	"Commissariat": Vector2(1, 1),
	"Grand Commissariat": Vector2(2,1),
	"Hôpital": Vector2(2, 2),
	"Mairie": Vector2(2, 2),
	"Musee": Vector2(2, 2),
	"Supermarché": Vector2(3,3),
	"Ecole": Vector2(2,2),
	"Centre Associatif": Vector2(2,2),
	"Complexe Sportif": Vector2(2,2),
	"Immeuble": Vector2(2,2),
	"Caserne": Vector2(2,2),
	"Theatre": Vector2(2,2),
	"Déchetterie": Vector2(3,3),
	"Monument obelisque": Vector2(1,1),
	"Monument Breizh": Vector2(1,1),
	"Monument chevalier": Vector2(2,2),
	"Monument loup": Vector2(2,2),
	"Poste": Vector2(1,1),
	"Lycée": Vector2(2,2),
	"Espace vert": Vector2(2,2),
	"Place de marché": Vector2(2,2),
	"Médiatheque": Vector2(2,2),
}

const INCOMES = {
	"Supérette": 0.5,
	"Supermarché": 2,
	"Place de marché": 1,
}
#Tex OFFSET value for preview in Buildings.gd
const OFFSET = {
	"Etablissement de santé": Vector2(0, -88.023),
	"Office de tourisme": Vector2(-0.707,-77.886),
	"Immeuble": Vector2(-265.922,-110.165),
	"Maison 1": Vector2(0,-91.457),
	"Maison 2": Vector2(0, -43.419),
	"Grande maison": Vector2(-258.268,-73.563),
	"Maison 3": Vector2(0.933,-31.09),
	"Supérette": Vector2(0.559,-44.763),
	"Commissariat": Vector2(0, -102.688),
	"Hôpital": Vector2(-265.266, -227.055),
	"Mairie": Vector2(-244.353, -141.372),
	"Musee": Vector2(-264.952, -22.964),
	"Supermarché": Vector2(0, -120),
	"Ecole": Vector2(-265.944, -122.669),
	"Centre Associatif": Vector2(-262.54,-19.197),
	"Complexe Sportif": Vector2(-264.27,-59.601),
	"Caserne": Vector2(-263.807,-19.366),
	"Déchetterie": Vector2(0,0),
	"Theatre": Vector2(-262.66,-230.328),
	"Monument obelisque": Vector2(0,-56.68),
	"Monument Breizh": Vector2(0,-11.156),
	"Monument chevalier": Vector2(-263.777,-46.302),
	"Monument loup": Vector2(-263.945,-46.657),
	"Lycée": Vector2(-265.007,-126.073),
	"Espace vert": Vector2(-264.909,-71.994),
	"Place de marché": Vector2(-264.406,-9.526),
	"Médiatheque": Vector2(-266.678,-47.894),
	"Poste": Vector2(0.993,-62.996)
}

# Preload all textures
const TEXTURES = {
	"Complexe Sportif": preload("res://assets/sprites/buildings/complexe_sportif.png"),
	"Office de tourisme": preload("res://assets/sprites/buildings/office_de_tourisme.svg"),
	"Etablissement de santé": preload("res://assets/sprites/buildings/cabinet.svg"),
	"Supérette": preload("res://assets/sprites/buildings/superette.svg"),
	"Commissariat": preload("res://assets/sprites/buildings/commissariat.png"),
	"Mairie": preload("res://assets/sprites/buildings/mairiegauche.png"),
	"Hôpital": preload("res://assets/sprites/buildings/hopital.png"),
	"Maison 1": preload("res://assets/sprites/buildings/maison_1.svg"),
	"Grande maison": preload("res://assets/sprites/buildings/grande_maison.png"),
	"Maison 3": preload("res://assets/sprites/buildings/petite_maison.png"),
	"Maison 2": preload("res://assets/sprites/buildings/maison2droite.png"),
	"Immeuble": preload("res://assets/sprites/buildings/immeuble.svg"),
	"Musee": preload("res://assets/sprites/buildings/musee.png"),
	"Supermarché": preload("res://assets/sprites/buildings/supermarche.png"),
	"Ecole": preload("res://assets/sprites/buildings/Ecole.svg"),
	"Theatre": preload("res://assets/sprites/buildings/theatre.png"),
	"Centre Associatif": preload("res://assets/sprites/buildings/centre_asso.png"),
	"Caserne": preload("res://assets/sprites/buildings/caserne.png"),
	"Déchetterie": preload("res://assets/sprites/buildings/dechetterie.png"),
	"Monument obelisque": preload("res://assets/sprites/decor/monument_obelisque.png"),
	"Monument Breizh": preload("res://assets/sprites/decor/monument_brz.png"),
	"Monument chevalier": preload("res://assets/sprites/decor/monument_chevalier.png"),
	"Monument loup": preload("res://assets/sprites/decor/monument_loup.png"),
	"Poste": preload("res://assets/sprites/buildings/poste.png"),
	"Lycée": preload("res://assets/sprites/buildings/lycee.png"),
	"Espace vert": preload("res://assets/sprites/buildings/espace_vert.png"),
	"Place de marché": preload("res://assets/sprites/buildings/Place_de_marche.png"),
	"Médiatheque": preload("res://assets/sprites/buildings/Mediatheque.png")
}

const INFLATION = {
	"Complexe Sportif": 50,
	"Office de tourisme": 50,
	"Etablissement de santé": 10,
	"Supérette": 30,
	"Commissariat": 30,
	"Hôpital": 30,
	"Maison 1": 10,
	"Grande maison": 30,
	"Maison 3": 10,
	"Maison 2": 10,
	"Immeuble": 30,
	"Musee": 50,
	"Supermarché": 50,
	"Ecole": 30,
	"Theatre": 50,
	"Centre Associatif": 50,
	"Caserne": 50,
	"Déchetterie": 50,
	"Monument obelisque": 20,
	"Monument Breizh": 20,
	"Monument chevalier": 20,
	"Monument loup": 20,
	"Poste": 20,
	"Lycée": 50,
	"Espace vert": 30,
	"Place de marché": 30,
	"Médiatheque": 50,
}
# The increase in max popuation for each building
const POPULATION_SPACE = {
	"Maison 1": 20,
	"Grande maison": 30,
	"Maison 2": 20,
	"Maison 3": 10,
	"Immeuble": 80
}

# The increase in Satisfaction for each building
const SATISFACTION_POINTS = {
	"Complexe Sportif": 50,
	"Caserne": 50,
	"Office de tourisme": 30,
	"Etablissement de santé": 30,
	"Hôpital": 30,
	"Commissariat": 20,
	"Musee": 50,
	"Ecole": 30,
	"Theatre": 20,
	"Centre Associatif": 20,
	"Déchetterie": 50,
#	"Banque": 30,
#	"Cinema": 35,
	"Lycée": 20,
	"Mediatheque": 20,
	"Poste": 20,
#	"Universite": 20,
	"Monument": 40,
	"Espace vert": 40,
	"Médiatheque": 20
}

# Buildings given every time the *population* gets to a certain level
const BUILDINGS_FROM_POP = {
	"Maison 1": 60,
	"Grande maison": 80,
	"Maison 3": 60,
	"Immeuble": 100,
	"Place de marché": 100,
#	"Cinema": 70,
	"Musee": 500,
	"Hôpital": 250,
	"Médiatheque": 100,
	"Poste": 100,
	"Lycée": 125,
	"Maison 2": 60,
#	"Universite": 150
}

# Buildings given every time the *MAX population* gets to a certain level
const BUILDINGS_FROM_MAX_POP = {
	"Espace vert": 150,
	"Supérette": 200
}

const PRIX = {
	"Complexe Sportif": 70,
	"Office de tourisme": 20,
	"Etablissement de santé": 20,
	"Maison 1": 10,
	"Grande maison": 30,
	"Maison 2": 20,
	"Maison 3": 20,
	"Immeuble": 40,
	"Mairie": 0,
	"Supérette":15,
	"Commissariat": 40,
	"Hôpital": 50,
	"Musee": 50,
	"Supermarché": 100,
	"Ecole": 20,
	"Theatre": 30,
	"Centre Associatif": 20,
	"Caserne": 40,
	"Poste": 25,
	"Lycée": 35,
	"Espace vert": 20,
	"Déchetterie": 40,
	"Monument obelisque": 50,
	"Monument Breizh": 50,
	"Monument chevalier": 50,
	"Monument loup": 50,
	"Médiatheque": 25,
	"Place de marché": 30,
}

#Buildings categories:
const ADMIN = {
#Administratif
	"Commissariat": 1,
	"Ecole": 1,
	"Lycée": 1,
	"Poste": 1,
}
const ASSOCIATIF = {
	"Centre Associatif": 1
}

const COMMERCIAL = {
	"Supérette": 1,
	"Supermarché": 1,
}

const HABITATION = {
	"Maison 1": 1,
	"Grande maison": 1,
	"Maison 2": 1,
	"Maison 3": 1,
	"Immeuble": 1,
}

const LOISIR = {
	"Complexe Sportif": 1,
	"Office de tourisme": 1,
	"Musee": 1,
	"Theatre": 1,
	"Espace vert": 1,
	"Médiatheque": 1,
}

const SANTE = {
	"Etablissement de santé": 1,
	"Hôpital": 1,
}

const MEDIUM_BUILDING = {
	# Vector2(2,2) buildings, Dict useful for destruction.
	"Ecole": 1,
	"Musee": 1,
	"Theatre": 1,
	"Centre Associatif": 1,
	"Complexe Sportif": 1,
	"Grande maison": 1,
	"Immeuble": 1,
	"Caserne": 1,
	"Monument obelisque": 1,
	"Monument Breizh": 1,
	"Monument chevalier": 1, 
	"Monument loup": 1,
	"Place de marché": 1,
	"Médiatheque": 1,
}

#decorations
const DECO = {
	"Monument obelisque": 1,
	"Monument Breizh": 1,
	"Monument chevalier": 1,
	"Monument loup": 1,
}


const BIG_BUILDING = {
	# Vector2(3,3) buildings, Dict useful for destruction.
	"Déchetterie": 1,
	"Supermarché": 1,
}

static func recover_money(building: String):
	PRIX[building] -= INFLATION[building]
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
	PRIX[building] += INFLATION[building]

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
