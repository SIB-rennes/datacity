extends Node

# Infinite amount of buildings
const INF_BUILDING = -1

# Constant Strings
const POPULATION = "Population"
const POPULATION_MAX = "Population max"
const SANTE = "Santé"
const EDUCATION = "Education"
const LOISIRS = "Loisirs"
const SECURITE = "Sécurité"



# List of building the player can build
var building_list = {
	"Mairie" : 1
}

# A Dictionnary of the event that occured
var event_occured = {}


# City data
var city_data = {
	POPULATION: 0, # The population
	POPULATION_MAX: 0, # Max population
	SANTE: 0,
	EDUCATION: 0,
	LOISIRS: 0,
	SECURITE: 0,
}


# Data points accumulated
var data_points = 0



func _ready():
	print("Loaded player data !")



static func use_building(building_name):
	# REduce if not inifnite
	if PlayerData.building_list[building_name] != PlayerData.INF_BUILDING:
		PlayerData.building_list[building_name] -= 1
	
	
	# Increase population space
	if building_name in BuildingsData.POPULATION_SPACE:
		PlayerData.city_data[PlayerData.POPULATION_MAX] += BuildingsData.POPULATION_SPACE[building_name]
		
		# TEMP
		PlayerData.city_data[PlayerData.POPULATION] = PlayerData.city_data[PlayerData.POPULATION_MAX]



static func add_building(building_name: String, amount: int):
	# If the building is not in the list
	if not building_name in PlayerData.building_list:
		PlayerData.building_list[building_name] = amount
	
	# Else if the building is not in infinite amount
	elif PlayerData.building_list[building_name] != PlayerData.INF_BUILDING:
		PlayerData.building_list[building_name] += amount



static func add_event_occurence(event_name: String):
	# Set the value to 1 for the first trigger
	if not event_name in PlayerData.event_occured:
		PlayerData.event_occured[event_name] = 1
	# Increment the count
	else:
		PlayerData.event_occured[event_name] += 1
