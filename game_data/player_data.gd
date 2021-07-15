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
	"Mairie" : 1 # Starts with only the Mairie
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
	
	# Update the city data
	if bonus[0] in PlayerData.city_data: 
		# Save old populations
		var old_pop = PlayerData.city_data[POPULATION]
		var old_pop_max = PlayerData.city_data[POPULATION_MAX]
		
		PlayerData.city_data[bonus[0]] += bonus[1]
		
		# Get the population difference
		update_population()
		
		# Save populations
		var pop = PlayerData.city_data[POPULATION]
		var pop_max = PlayerData.city_data[POPULATION_MAX]
		
		# Give new buildings
		give_new_buildings(pop, old_pop, pop_max, old_pop_max)
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
	# Get the minimum of the constraints
	var tab = 	[PlayerData.city_data[POPULATION_MAX], 
				PlayerData.city_data[SANTE], 
				PlayerData.city_data[EDUCATION], 
				PlayerData.city_data[LOISIRS], 
				PlayerData.city_data[SECURITE]]
				
	# The new population value
	var population = tab.min()
	PlayerData.city_data[POPULATION] = population



static func give_new_buildings(pop, old_pop, pop_max, old_pop_max):
	## POPULATION
	# For each building depending on POPULATION
	for building in BuildingsData.BUILDINGS_FROM_POP.keys():
		# Get the step
		var step = BuildingsData.BUILDINGS_FROM_POP[building]
		
		# Get the value before and after the construction
		var old_amount = floor(old_pop / step)
		var new_amount = floor(pop / step)
		
		#Give the buildings
		add_building(building, new_amount - old_amount)
		
	## MAX POPULATION
	# For each building depending on POPULATION_MAX
	for building in BuildingsData.BUILDINGS_FROM_MAX_POP.keys():
		# Get the step
		var step = BuildingsData.BUILDINGS_FROM_MAX_POP[building]
		
		# Get the value before and after the construction
		var old_amount = floor(old_pop_max / step)
		var new_amount = floor(pop_max / step)
		
		#Give the buildings
		add_building(building, new_amount - old_amount)
