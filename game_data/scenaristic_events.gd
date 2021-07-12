extends Node


#====> Possible conditions :
	# (x) represents the function parameter

# "built(x)" : Dictionnary {"Building": [min_count, max_count]}
# "probability(x)" : number between 0 and 1
# "population_space(x)" : [min, max]
# "population(x)" : [min, max]


# Dictionnary of events Names and conditions
const EVENTS_CONDITIONS = {
	"MairieConstruite": {
		"built(x)": {"Mairie": [1, 1]}, 
		"probability(x)": 1,
		"population_space(x)": [10, 10],
	}
}


const DIALOG_FILES = {
	"MairieConstruite": "res://scenarios/beginning/mairie_built.json",
}


const SUMMARIES = {
	"MairieConstruite": "La secrétaire de mairie veut vous voir.",
}


const OFFERED_BUILDINGS = {
	"MairieConstruite": {
		"Maison 1": 3,
		"Maison 2": 2,
		"Maison 3": 1,
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
	
	# Returns true if the population space is in between
	return PlayerData.population_space >= mini and PlayerData.population_space <= maxi 



func population(min_max: Array):
	# Get the bounds
	var mini = min_max[0]
	var maxi = min_max[1]
	
	# Returns true if the population space is in between
	return PlayerData.population >= mini and PlayerData.population <= maxi 
