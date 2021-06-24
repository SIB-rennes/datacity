extends Node2D

# A Reference to the Dialog label
onready var dialog_line = $UI/TextPanel/DialogLine

# Storing parser, data and block for the dialog parsing
var parser
var dialogue_data
var block


func _ready():
	# create a parser
	parser = WhiskersParser.new()
	
	# Get the dialogue data
	dialogue_data = parser.open_whiskers("res://scenarios/dialog_intro.json")
	
	# Get the first dialog bloc
	block = parser.start_dialogue(dialogue_data)
	
	# Update the dialog
	update_dialog_line()


# Process inputs
func _input(event):
	# if we touched the screen or the mouse
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			process_player_click()
			
	# If we pressed space
	elif event is InputEventKey:
		if event.pressed and event.unicode == KEY_SPACE:
			process_player_click()



func process_player_click():
	print("TOUCHED :D")
	
	if block.is_final:
		print("That was the last dialog !")
	else:
		# TEMP ANSWER
		var answer = 0
		
		# Change the Dialog
		if block.options.size() > answer:
			block = parser.next(block.options[answer].key)
		else:
			block = parser.next("")
			
		update_dialog_line()
	


func update_dialog_line():
	# Set the dialog line on the UI
	dialog_line.text = block.text
