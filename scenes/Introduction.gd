extends Node2D

# Preload the Dialog scene
var dialog_scene = preload("res://scenes/DialogScene.tscn").instance()



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
