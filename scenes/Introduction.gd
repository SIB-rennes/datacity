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


func start_dialog():
	var dialog_conf = "res://scenarios/dialog_conference.json"
	
	# Adds the child to the conference
	add_child(dialog_scene)
	
	# start the dialog for the conference
	dialog_scene.start_dialog_event(dialog_conf)

