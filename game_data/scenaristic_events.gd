extends Node


#====> Possible conditions :
	# (x) represents the function parameter

# "built(x)" : Dictionnary {"Building": [min_count, max_count]}
# "probability(x)" : number between 0 and 1
# "population_space(x)" : [min, max]
# "population(x)" : [min, max]


# Dictionnary of events Names and conditions
const EVENTS_CONDITIONS = {
	"MairieConstruite": { # Dialogues after the first building
		"built(x)": {"Mairie": [1, 1]},
		"not had_event(x)": ["MairieConstruite"],
	},
	"PremieresMaisons": { # Dialogues after the first houses
		"built(x)": {"Maison 1": [1, 1], "Maison 2": [1, 1], "Maison 3": [1, 1]},
		"not had_event(x)": ["PremieresMaisons"],
	},
	### <=====> ###  Pedagogical events
	"PublierDonneesTransports": {
		"had_event(x)": ["PremieresMaisons"],
		"not had_event(x)": ["PublierDonneesTransports"], # Not again 
		"probability(x)": .3, # 30% chance after each building
		"population_over(x)": 50 # The event won't trigger if the population count is under x
	}
}


const DIALOG_FILES = {
	"MairieConstruite": "res://scenarios/beginning/mairie_built.json",
	"PremieresMaisons": "res://scenarios/beginning/premieres_maisons.json",
	"PublierDonneesTransports": "res://scenarios/pedagogical/publier_donnees_transports.json",
}


const SUMMARIES = {
	"MairieConstruite": "La secrétaire de mairie veut vous voir.",
	"PremieresMaisons": "La secrétaire de mairie veut vous voir.",
	"PublierDonneesTransports": "Vous croisez un citoyen dans un parc.",
}


# Buildings offered at the end of the dialog, no matter the result
const OFFERED_BUILDINGS = {
	"MairieConstruite": {
		"Maison 1": 1,
		"Maison 2": 1,
		"Maison 3": 1,
	},
	"PremieresMaisons": {
		"Hopital": 1,
		"Commissariat": 1,
		"Ecole": 1,
	}
}


# Current buildings in the city
var buildings: Dictionary


## Returns null if no event was triggered
func trigger_event(buildings_in_city):
	# Evaluating expression
	var expression = Expression.new()

	# Save the buildings
	buildings = buildings_in_city

	# Check each event
	for event_name in EVENTS_CONDITIONS.keys():
		# Get the conditions
		var event_cond = EVENTS_CONDITIONS.get(event_name, {})
		
		# Invalidated
		var invalid = false
		
		# Check each condition
		for condition in event_cond.keys():
			# Get the condition parameter
			var param = event_cond[condition]
			
			# If this condition is not met, go to the next 
			expression.parse(condition, ["x"])
			if not expression.execute([param], self):
				# break exits current for loop
				invalid = true
				break
		
		if not invalid:
			return event_name
	
	# No event was returned 
	return null



## P must be between 0 and 1
func probability(p):
	# Get a random number between 0 and 1 and compare it 
	return randf() <= p



# Check if the building
func built(buildings_needed: Dictionary):
	# For each building in the dic
	for building in buildings_needed.keys():
		# Get the Min and max values
		var mini = buildings_needed[building][0]
		var maxi = buildings_needed[building][1]
		
		# Count in the city
		var count = buildings.get(building, 0)
		
		if count < mini or count > maxi:
			return false
			
	# Every building condition was met
	return true



func population_space(min_max: Array):
	# Get the bounds
	var mini = min_max[0]
	var maxi = min_max[1]
	
	# Returns true if the max population is in between
	var pop_max = PlayerData.city_data[PlayerData.POPULATION_MAX]
	return pop_max >= mini and pop_max <= maxi 



func population(min_max: Array):
	# Get the bounds
	var mini = min_max[0]
	var maxi = min_max[1]
	
	# Returns true if the population space is in between
	var population = PlayerData.city_data[PlayerData.POPULATION]
	return population >= mini and population <= maxi 


func population_over(mini: int):
	# Check if the Player population is over a given value
	var population = PlayerData.city_data[PlayerData.POPULATION]
	return population >= mini


func had_event(event_names: Array):
	# Check if each event occured
	for event in event_names:
		if not event in PlayerData.event_occured:
			return false
	
	# All were found
	return true
