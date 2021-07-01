extends Node2D

# Get the Dialog scene
onready var dialog_scene = $DialogScene


# Introduction dialogs
const DIALOG_INTRO = "res://scenarios/dialog_intro.json"
const DIALOG_CONFERENCE = "res://scenarios/dialog_conference.json"



func _ready():
	# Deactivates the dialog scene
	dialog_scene.set_process_input(false)
	
	# Connect the dialog finished to start the conference
	dialog_scene.connect("dialog_finished", self, "tuto_dialog_finished")


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
	
	# Allow input process again
	dialog_scene.set_process_input(true)


func tuto_dialog_finished():
	print("Dialog tuto fini ! ")
	
	# Block inputs for the fading
	dialog_scene.set_process_input(true)
	
	# Start the fading again
	$ZIndexer/FadingScreen.show()
	$ZIndexer/FadingScreen.fade_in()
	
	# Connect the fading end with the conference start
	$ZIndexer/FadingScreen.disconnect("fade_finished", self, "start_tuto_dialogs")
	$ZIndexer/FadingScreen.connect("fade_finished", self, "start_conference")
	
	
func start_conference():
	# start the dialog for the conference
	dialog_scene.start_dialog_event(DIALOG_CONFERENCE)
	
	# Hide the fading screen
	$ZIndexer/FadingScreen.hide()
	
	# Allow input process again
	dialog_scene.set_process_input(true)
	
	# Reconnect the dialog scene
	$ZIndexer/FadingScreen.disconnect("fade_finished", self, "start_conference")
	$ZIndexer/FadingScreen.connect("fade_finished", self, "end_conference")


func end_conference():
	print("La conference est finie ! il faut charger la suite")
	
