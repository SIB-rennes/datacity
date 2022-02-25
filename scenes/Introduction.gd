## The goal of this file is to manage the Introduction scene
## And the sequence of dialogs in it 

extends Control

# Get the Dialog scene
onready var dialog_scene = $DialogScene


# Introduction dialogs
const DIALOG_PRE_INTRO = "res://scenarios/pre_intro.json"
const DIALOG_POST_INSCRIPTION = "res://scenarios/post_inscription.json"
const DIALOG_INTRO = "res://scenarios/dialog_intro.json"
const DIALOG_CONFERENCE = "res://scenarios/dialog_conference.json"
const DIALOG_POST_CONFERENCE = "res://scenarios/dialog_post_conference.json"



enum State {
	PRE_INTRO,
	FORMULAIRE_SCENE,
	POST_INSCRIPTION,
	NEWSPAPER,
	TUTO_DIALOG,
	CONFERENCE,
	POST_CONFERENCE,
	STARTING_CITY
}

# State variables
var current_state = State.PRE_INTRO
var next_state = State.FORMULAIRE_SCENE



func _ready():
	$formulaire.hide()
	#skip intro: debug
#	get_tree().change_scene("res://scenes/CityBuilder.tscn")
	# Deactivates the dialog scene
	# Connect the dialog end to finish_state()
	dialog_scene.connect("dialog_finished", self, "finish_state")
	
	dialog_scene.set_process_input(true)
	
	dialog_scene.start_dialog_event(DIALOG_PRE_INTRO)
	

func start_next_state():
	# Allow processing of dialog inputs
#	dialog_scene.set_process_input(true)
#	
#
	# Switch states
	current_state = next_state
	set_next_state()
	
	# Hide the fading screen
#	$ZIndexer/FadingScreen.hide()
	
	match current_state:
	
		State.FORMULAIRE_SCENE:
			dialog_scene.set_process_input(false)
			
			dialog_scene.hide()

			$formulaire.show()
		# Starts the Dialog with a tutorial
		State.POST_INSCRIPTION:
			$formulaire.hide()
			
			dialog_scene.show()
			dialog_scene.set_process_input(true)
			dialog_scene.start_dialog_event(DIALOG_POST_INSCRIPTION)
		
		State.NEWSPAPER:
			dialog_scene.set_process_input(false)
			dialog_scene.hide()
			
			$NewsPaper.change_state()
			
			$Background.show()
			$NewsPaper.show()
		

		State.TUTO_DIALOG:
			dialog_scene.set_process_input(true)
			# Hide the desk scenery
			$Background.hide()
			$NewsPaper.hide()
		
			# Shows the Dialog scene
			dialog_scene.show()
			dialog_scene.start_dialog_event(DIALOG_INTRO, true)
			
		# Starts the conference dialog
		State.CONFERENCE:
			dialog_scene.set_process_input(true)
			dialog_scene.start_dialog_event(DIALOG_CONFERENCE)
			
		# Starts the post conference dialog
		State.POST_CONFERENCE:
			dialog_scene.set_process_input(true)
			dialog_scene.start_dialog_event(DIALOG_POST_CONFERENCE)
			
		# Starts the city game
		State.STARTING_CITY:
			get_tree().change_scene("res://scenes/CityBuilder.tscn")



func finish_state():
	# Disable processing of dialog inputs
	dialog_scene.set_process_input(false)
	
	# Start the fading animation
	$ZIndexer/FadingScreen.show()
	$ZIndexer/FadingScreen.fade_in()



func set_next_state():
	match current_state:
		State.FORMULAIRE_SCENE:
			next_state = State.POST_INSCRIPTION
		State.POST_INSCRIPTION:
			next_state = State.NEWSPAPER
		State.NEWSPAPER:
			next_state = State.TUTO_DIALOG
		State.TUTO_DIALOG:
			next_state = State.CONFERENCE
		State.CONFERENCE:
			next_state = State.POST_CONFERENCE
		State.POST_CONFERENCE:
			next_state = State.STARTING_CITY
