extends Node2D

# Get the Dialog scene
onready var dialog_scene = $DialogScene


func _ready():
	# Deactivates the dialog scene
	dialog_scene.set_process_input(false)


func _input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			process_player_click()


func process_player_click():
	pass



func _on_FadingScreen_fade_finished():
	var dialog_conf = "res://scenarios/dialog_conference.json"
	
	# Show the child
	dialog_scene.show()
	
	# start the dialog for the conference
	dialog_scene.start_dialog_event(dialog_conf)
	
	# Hide the newspapers, the background and the fading screen
	$Background.hide()
	$NewsPaper.hide()
	$ZIndexer/FadingScreen.hide()
