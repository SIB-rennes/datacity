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
	"Mairie" : 1,
	"Maison1" : 1,
	"Maison2" : 1,
	"Maison3" : 1,
	"Immeuble" : 1,
	"Pharmacie": 50,
	"Hopital": 100,
	"Grand Hopital": 250,
	"Ecole": 200,
	"Grande Ecole": 400,
	"Cafe": 50,
	"Grand Cafe": 100,
	"Theatre": 100,
	"Parc": 100,
	"Restaurant": 250,
	"Musee": 250,
	"Commissariat": 100,
	"Grand Commissariat": 250,
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
	
	
	# Get the building bonus
	var bonus = BuildingsData.get_building_bonus(building_name)
	
	print(bonus)
	
	# Update the city data
	if bonus[0] in PlayerData.city_data: 
		PlayerData.city_data[bonus[0]] += bonus[1]
		
		# Get the population difference
		var diff_pop = update_population()
		print("Diff pop : " + String(diff_pop))
	else:
		print("Can't find the bonus " + bonus[0])



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


# update the population count and returns the difference
static func update_population():
	# The old ppulation
	var old_pop = PlayerData.city_data[POPULATION]
	
	# Get the minimum of the constraints
	var tab = 	[PlayerData.city_data[POPULATION_MAX], 
				PlayerData.city_data[SANTE], 
				PlayerData.city_data[EDUCATION], 
				PlayerData.city_data[LOISIRS], 
				PlayerData.city_data[SECURITE]]
				
	# The new population value
	var population = tab.min()
	PlayerData.city_data[POPULATION] = population
	
	return population - old_pop
