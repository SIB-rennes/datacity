extends Object
class_name ScenariosData


#=====> Data

## Some scenarios can have instances (godot scripts)
## with variables and methods that can be used in Whisker expressions
const INSTANCES_PATH = {
	# Conference
	"res://scenarios/dialog_conference.json": 
		"res://scenarios/dialog_conference_variables.gd",
		
	"res://scenarios/dialog_intro.json":
		"res://scenarios/dialogs_custom_variables.gd",
	
	"res://scenarios/beginning/tutorial.json":
		"res://scenarios/dialogs_custom_variables.gd",

	"res://scenarios/pedagogical/premier_batiment_de_commerce.json":
		"res://scenarios/dialogs_custom_variables.gd",

	"res://scenarios/pedagogical/deblocage_complexe_sportif.json":
		"res://scenarios/dialogs_custom_variables.gd",
	
	"res://scenarios/pedagogical/annuaire_sante.json":
		"res://scenarios/dialogs_custom_variables.gd",
	
	"res://scenarios/pedagogical/risques.json":
		"res://scenarios/dialogs_custom_variables.gd",
	
	"res://scenarios/pedagogical/tourisme.json":
		"res://scenarios/dialogs_custom_variables.gd",
	
	"res://scenarios/pedagogical/CentreAssociatif_construit.json":
		"res://scenarios/dialogs_custom_variables.gd",
	
	"res://scenarios/pedagogical/donnees_urbanisme.json":
		"res://scenarios/dialogs_custom_variables.gd",

	"res://scenarios/pedagogical/infos_conference.json":
		"res://scenarios/dialogs_custom_variables.gd",
		
	"res://scenarios/pedagogical/citoyen_enerve.json":
		"res://scenarios/dialogs_custom_variables.gd",
		
	"res://scenarios/pedagogical/retour_conferencier_1.json":
		"res://scenarios/dialogs_custom_variables.gd",
		
	"res://scenarios/pedagogical/retour_conferencier_3.json":
		"res://scenarios/dialogs_custom_variables.gd",
		
	"res://scenarios/pedagogical/retour_conferencier_2.json":
		"res://scenarios/dialogs_custom_variables.gd",

	"res://scenarios/pedagogical/donnees_hopitaux.json":
		"res://scenarios/dialogs_custom_variables.gd",

	"res://scenarios/pedagogical/droits_donnees.json":
		"res://scenarios/dialogs_custom_variables.gd",
		
	"res://scenarios/pedagogical/last_dialog.json":
		"res://scenarios/dialogs_custom_variables.gd",
		
	"res://scenarios/pedagogical/mairie_built.json":
		"res://scenarios/dialogs_custom_variables.gd",

	"res://scenarios/pedagogical/deliberations.json":
		"res://scenarios/dialogs_custom_variables.gd",
		
	"res://scenarios/pedagogical/premieres_maisons.json":
		"res://scenarios/dialogs_custom_variables.gd",
		
	"res://scenarios/pedagogical/CentreAssociatif.json":
		"res://scenarios/dialogs_custom_variables.gd",
}



#=====> Functions
static func get_scenario_instance(scenario):
	# Instanciate the context if there is a script in the dict
	if scenario in INSTANCES_PATH:
		# Loads the GdScript and instanciate
		return load(INSTANCES_PATH.get(scenario)).new()
	
	else:
		return null
