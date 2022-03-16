extends Node

#====> Possible conditions :
	# (x) represents the function parameter

# "built(x)" : Dictionnary {"Building": [min_count, max_count]}
# "probability(x)" : number between 0 and 1
# "population_space(x)" : [min, max]
# "population(x)" : [min, max]


# Dictionnary of events Names and conditions
const EVENTS_CONDITIONS = {
	"Tutorial":{
		"built(x)": {"Maison 1": [1, 1]},
		"not had_event(x)": ["Tutorial"],
	},

	"MairieConstruite": { # Dialogues after the first building
		"had_event(x)": ["Tutorial"],
		"not had_event(x)": ["MairieConstruite"],
	},

	"PremierCommerce":{
		"had_event(x)" : ["Tutorial"],
		"not had_event(x)" : ["PremierCommerce"],
	},

	"PremieresMaisons": { # Dialogues after the first houses
		"built(x)": {"Maison 1": [1, 100], "Maison 2": [1, 100], "Maison 3": [1, 100]},
		"not had_event(x)": ["PremieresMaisons"],
	},

	"ComplexeSportif":{
		"not had_event(x)" : ["ComplexeSportif"],
		"population_over(x)": 40
	},
	
	"Etablissement de santé":{
		"not had_event(x)" : ["Etablissement de santé"],
		"population_over(x)": 60
	},
	
	"Deliberations":{
		"not had_event(x)" : ["Deliberations"],
		"population_over(x)":20
	},
	### <=====> ###  Pedagogical events
	"CentreAssociatif":{
		"had_event(x)": ["PremieresMaisons"],
		"not had_event(x)": ["CentreAssociatif"],
		"population_over(x)" : 100
	},
	
	"Commissariat":{
		"not had_event(x)": ["Commissariat"],
		"population_over(x)" : 80
	},

	"Tourisme":{
		"not had_event(x)": ["Tourisme"],
		"population_over(x)" : 80
	},
	
	"CentreAssociatif_construit":{
		"built(x)": {"Centre Associatif": [1, 1]},
		"not had_event(x)": ["CentreAssociatif_construit"],
		"probability(x)": 1,
		"population_over(x)": 0
	},
	"DonneesUrbanisme": {
		"had_event(x)": ["PremieresMaisons"],
		"not had_event(x)": ["DonneesUrbanisme"], # Not again 
		"probability(x)": .3, # 30% chance after each building
		"population_over(x)": 80 # The event won't trigger if the population count is under x
	},

	"InfosConference": {
		"had_event(x)": ["PremieresMaisons"],
		"not had_event(x)": ["InfosConference"], # Not again 
		"probability(x)": .3, # 30% chance after each building
		"population_over(x)": 80 # The event won't trigger if the population count is under x
	},
	"CitoyenEnerve": {
		"had_event(x)": ["InfosConference"],
		"not had_event(x)": ["CitoyenEnerve"], # Not again 
		"probability(x)": .5, # 30% chance after each building
		"population_over(x)": 80 # The event won't trigger if the population count is under x
	},
	
	
	"RetourConferencier_1": {
		"had_event(x)":  ["PremieresMaisons"],
		"not had_event(x)": ["RetourConferencier_1"], # Not again 
		"probability(x)": .3, # 30% chance after each building
		"population_over(x)": 80 # The event won't trigger if the population count is under x
	},
	"RetourConferencier_2": {
		"had_event(x)":  ["RetourConferencier_1"], # Need the previous Event
		"not had_event(x)": ["RetourConferencier_2"], # Not again 
		"probability(x)": .3, # 30% chance after each building
		"population_over(x)": 80 # The event won't trigger if the population count is under x
	},
	"RetourConferencier_3": {
		"had_event(x)":  ["RetourConferencier_2"], # Need the previous Event
		"not had_event(x)": ["RetourConferencier_3"], # Not again 
		"probability(x)": .5, # 30% chance after each building
		"population_over(x)": 80
	},
	
	
	"DonneesHopitaux": {
		"had_event(x)":  ["PremieresMaisons"],
		"not had_event(x)": ["DonneesHopitaux"], # Not again 
		"probability(x)": .2, # 30% chance after each building
		"population_over(x)": 80 # The event won't trigger if the population count is under x
	},
	
	
	"DroitsDonnees": {
		"had_event(x)":  ["PremieresMaisons"],
		"not had_event(x)": ["DroitsDonnees"], # Not again 
		"probability(x)": .2, # 30% chance after each building
		"population_over(x)": 80 # The event won't trigger if the population count is under x
	},
	
	
	# Dernier Scénario
	"DernierScenario": {
		"had_event(x)":  [ "CitoyenEnerve", "RetourConferencier_3", "DonneesHopitaux", "DroitsDonnees"],
		"not had_event(x)": ["DernierScenario"], # Not again 
	},
}


const DIALOG_FILES = {
	"Tutorial":"res://scenarios/beginning/tutorial.json",
	"MairieConstruite": "res://scenarios/beginning/mairie_built.json",
	"PremierCommerce" : "res://scenarios/pedagogical/premier_batiment_de_commerce.json",
	"Commissariat" : "res://scenarios/pedagogical/risques.json",
	"ComplexeSportif": "res://scenarios/pedagogical/deblocage_complexe_sportif.json",
	"Deliberations": "res://scenarios/beginning/deliberations.json",
	"PremieresMaisons": "res://scenarios/beginning/premieres_maisons.json",
	"CentreAssociatif": "res://scenarios/beginning/CentreAssociatif.json",
	"CentreAssociatif_construit":"res://scenarios/pedagogical/CentreAssociatif_construit.json",
	"DonneesUrbanisme": "res://scenarios/pedagogical/donnees_urbanisme.json",
	"InfosConference": "res://scenarios/pedagogical/infos_conference.json",
	"CitoyenEnerve": "res://scenarios/pedagogical/citoyen_enerve.json",
	"Etablissement de santé": "res://scenarios/pedagogical/annuaire_sante.json",
	"RetourConferencier_1": "res://scenarios/pedagogical/retour_conferencier_1.json",
	"RetourConferencier_2": "res://scenarios/pedagogical/retour_conferencier_2.json",
	"RetourConferencier_3": "res://scenarios/pedagogical/retour_conferencier_3.json",
	"DonneesHopitaux": "res://scenarios/pedagogical/donnees_hopitaux.json",
	"Tourisme": "res://scenarios/pedagogical/tourisme.json",
	
	"DroitsDonnees": "res://scenarios/pedagogical/droits_donnees.json",
		
	"DernierScenario": "res://scenarios/last_dialog.json",
}


const SUMMARIES = {
	"Tutorial": "Ici vous pourrez voir le sommaire de l'événement",
	"MairieConstruite": "Votre adjointe veut vous voir.",
	"PremierCommerce": "Un PDG d'entreprise souhaite s'entretenir avec vous.",
	"ComplexeSportif": "Une citoyenne souhaite vous voir.",
	"PremieresMaisons": "Votre adjointe veut vous voir.",
	"Deliberations": "Votre adjointe veut vous voir.",
	"CentreAssociatif": "L'adjointe souhaite s'entretenir avec vous.",
	"CentreAssociatif_construit": "Le représentant du centre associatif souhaite vous voir.",
	"DonneesUrbanisme": "Une citoyenne est venue vous voir.",
	"InfosConference": "Vous croisez une citoyenne.",
	"CitoyenEnerve": "Un citoyen tient à vous parler.",
	"Commissariat" : "Une habitante souhaite vous voir. ",
	"Tourisme": "Une citoyenne souhaite vous voir.",
	"Etablissement de santé": "Un membre du personnel de santé souhaite vous voir.",
	"RetourConferencier_1": "Votre adjointe a un message pour vous.",
	"RetourConferencier_2": "Le conférencier est revenu vous voir.",
	"RetourConferencier_3": "Le conférencier est revenu vous voir.",
	
	"DonneesHopitaux": "Votre adjointe a une proposition à vous faire.",
	
	"DroitsDonnees": "Votre adjointe veut vous parler.",
	
	"DernierScenario": "Votre adjointe a un message pour vous.",
}


# Buildings offered at the end of the dialog, no matter the result
const OFFERED_BUILDINGS = {
	"Tutorial": {
		"Maison 1": 1,
	},
	
	"MairieConstruite": {
		"Ecole": 1,
	},
	
	"PremierCommerce": {
		"Supérette": 1,
	},

	"ComplexeSportif": {
		"Complexe Sportif": 1,
	},

	"PremieresMaisons": {
		"Hopital": 1,
		"Commissariat": 1,
		"Ecole": 1,
	},
	"CentreAssociatif": {
		"Centre Associatif": 1,
	},
	"Etablissement de santé":{
		"Etablissement de santé":1
	},

	"Commissariat": {
		"Commissariat": 1
	},
	
	"Tourisme": {
		'Office de tourisme': 1
	},
	
	"Deliberations": {
		"Maison 1": 1
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
