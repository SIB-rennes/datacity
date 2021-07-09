extends Node

# Infinite amount of buildings
const INF_BUILDING = -1


# List of building the player can build
var building_list = {
	"Mairie" : 1
}

# City Population
var population = 0

# City population space
var population_space = 0

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
		PlayerData.population_space += BuildingsData.POPULATION_SPACE[building_name]
		
		# TEMP
		PlayerData.population = PlayerData.population_space



static func add_building(building_name: String, amount: int):
	# If the building is not in the list
	if not building_name in PlayerData.building_list:
		PlayerData.building_list[building_name] = amount
	
	# Else if the building is not in infinite amount
	elif PlayerData.building_list[building_name] != PlayerData.INF_BUILDING:
		PlayerData.building_list[building_name] += amount
