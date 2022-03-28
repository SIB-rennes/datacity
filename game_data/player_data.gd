extends Node

# Infinite amount of buildings
const INF_BUILDING = -1

# Constant Strings
const POPULATION = "Population"
const POPULATION_MAX = "Population max"
const SATISFACTION = "Satisfaction"
const PRIX = "Prix"
const INCOMES = "Revenus"

const SAVEFILE = "user://savegame.save"

# List of building the player can build

var building_limit = {
	"Maison 1": 2,
	"Office de tourisme": 1, 
	"Etablissement de santé": 1,
	"Supérette": 1,
	"Complexe Sportif": 1,
	"Commissariat": 1,
	"Grande maison": 1, 
	"Maison 3": 1,
	"Immeuble": 1,
	"Musee": 1,
	"Supermarché": 1,
	"Ecole": 1,
	"Theatre": 1,
	"Centre Associatif": 1,
	"Caserne": 1,
	"Déchetterie": 1
}

var building_list = {
	"Maison 1": 1,
	"Grande maison": 1, 
	"Maison 3": 1,
	"Ecole": 1,
	"Office de tourisme": 1, 
	"Etablissement de santé": 1,
	"Supérette": 1,
	"Commissariat": 1,
	"Immeuble": 1,
	"Musee": 1,
	"Supermarché": 1,
	"Complexe Sportif": 1,
	"Theatre": 1,
	"Centre Associatif": 1,
	"Caserne": 1,
	"Déchetterie": 1
}


var building_limit_max = {
	#The real limit is the number -1 (it's substract by 1)
	"Maison 1":51,
	"Office de tourisme": 2, 
	"Etablissement de santé": 6,
	"Supérette": 6,
	"Complexe Sportif": 2,
	"Commissariat": 4,
	"Mairie": 2,
	"Hopital": 3,
	"Grande maison": 6, 
	"Maison 3": 51,
	"Immeuble": 11,
	"Musee": 2,
	"Supermarché": 2,
	"Ecole": 6,
	"Theatre": 2,
	"Centre Associatif": 2,
	"Caserne": 3,
	"Déchetterie": 2
}

var building_grade={
	"Maison 1": 1,
	"Grande maison": 1,
	"Maison 3": 1,
	"Ecole": 1,
	"Etablissement de santé": 1,
}

# A Dictionnary of the event that occured
var event_occured = {}


# City data
var city_data = {
	POPULATION: 0, # The population
	POPULATION_MAX: 0, # Max population
	SATISFACTION: 0,
	PRIX: 0,
}

var options_selected = ""
#for hide the tutorial panel.
var save_found = false
# Data points accumulated
var data_points = 500

#up buildings limits of all building, depending on population
var limit_level = "0"
# Incomes accumulated
var incomes = 0

var must_load_save = true

# Gender chosen by the player
var gender = null
var city = "not defined"
# Bureau choice
var bureau = "not defined"

#tuto variable
var tuto_advancement = false

func _ready():
	print("Loaded player data !")

func _physics_process(delta):
	#When you destroy a building
	if PlayerData.city_data[POPULATION] < 100 && limit_level == "1":
		limit_level = "0"
		for building in PlayerData.building_grade:
			if PlayerData.building_limit[building] < PlayerData.building_limit_max[building]:
				PlayerData.building_limit[building] = PlayerData.building_limit[building] - 1
	#Limit for building depending on population.
	elif PlayerData.city_data[POPULATION] > 500 && limit_level == "0":
		limit_level = "1"
		for building in PlayerData.building_grade:
			if PlayerData.building_limit[building] < PlayerData.building_limit_max[building]:
				PlayerData.building_limit[building] = PlayerData.building_limit[building] + 1

func recover(building_name):
		#Get the building bonus
	var bonus = BuildingsData.get_building_bonus(building_name)
	BuildingsData.recover_money(building_name)
	BuildingsData.recover_incomes(building_name)
	PlayerData.building_list[building_name] -= 1
	
	#update the city data
	if bonus[0] in PlayerData.city_data:
		#save the old populations
		var old_pop = PlayerData.city_data[POPULATION]
		var old_pop_max = PlayerData.city_data[POPULATION_MAX]
		
		PlayerData.city_data[bonus[0]] -= bonus[1]
		
		#get the population difference
		update_population()
		
		#Save populations
		var pop = PlayerData.city_data[POPULATION]
		var pop_max = PlayerData.city_data[POPULATION_MAX]
		
		#give new buildings
		give_new_buildings(pop, old_pop, pop_max, old_pop_max)
	else:
		print("can't find the bonus" + bonus[0])

static func use_building(building_name):
	# REduce if not inifnite
	if PlayerData.building_list[building_name] != PlayerData.INF_BUILDING:
		PlayerData.building_list[building_name] += 1
	
	
	# Get the building bonus
	var bonus = BuildingsData.get_building_bonus(building_name)
	BuildingsData.buildings_price(building_name)
	BuildingsData.building_incomes(building_name)
	
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
		if PlayerData.building_limit[building_name] < PlayerData.building_limit_max[building_name]:
			PlayerData.building_limit[building_name] += amount

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
				PlayerData.city_data[SATISFACTION]]
#				PlayerData.city_data[PRIX]]

	# The new population value
	var population = tab.min()
#	var population = PlayerData.city_data[SATISFACTION]
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
