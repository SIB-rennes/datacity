extends Node2D

# Get the Dialog scene
onready var dialog_scene = $DialogScene


# Introduction dialogs
const DIALOG_INTRO = "res://scenarios/dialog_intro.json"
const DIALOG_CONFERENCE = "res://scenarios/dialog_conference.json"



func _ready():
	# Deactivates the dialog scene
	dialog_scene.set_process_input(false)


func _input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			process_player_click()


func process_player_click():
	pass



func start_tuto_dialogs():
	# Show the child
	dialog_scene.show()
	
	# start the dialog for the conference
	dialog_scene.start_dialog_event(DIALOG_INTRO, true)
	
	# Hide the newspapers, the background and the fading screen
	$Background.hide()
	$NewsPaper.hide()
	$ZIndexer/FadingScreen.hide()

