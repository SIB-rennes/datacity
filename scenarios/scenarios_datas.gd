extends Object
class_name ScenariosData


#=====> Data

## Some scenarios can have instances (godot scripts)
## with variables and methods that can be used in Whisker expressions
const INSTANCES_PATH = {
	# Conference
	"res://scenarios/dialog_conference.json": 
		"res://scenarios/dialog_conference_variables.gd"
}




#=====> Functions
static func get_scenario_instance(scenario):
	# Instanciate the context if there is a script in the dict
	if scenario in INSTANCES_PATH:
		# Loads the GdScript and instanciate
		return load(INSTANCES_PATH.get(scenario)).new()
	
	else:
		return null
