extends Control


# Signal when dialog is finished
signal dialog_finished



# A Reference to the Dialog label
onready var dialog_line = $UI/TextPanel/DialogLine

# The background sprite
onready var background_sprite = $Background

# The character sprite
onready var character_sprite = $Character


# The container for the answer buttons
onready var answer_container = $UI/AnswerContainer

# Preload the button model
var answer_button = preload("res://ui/answer_button.tscn")


# Sound
onready var sound_player = $SoundPlayer
var sound_dialog_click = preload("res://assets/sounds/clic_dialog.wav")
var sound_answer_click = preload("res://assets/sounds/clic_answer.wav")


# Data for the scenarios
var scenarios_data = ScenariosData.new()



# Storing parser, data and block for the dialog parsing
var parser
var dialogue_data
var block


# Display delay, to prevent the answers from popping too fast
const DELAY_BEFORE_DISPLAY = 1.0
onready var timer_display = $TimerDisplay


# Answer delay, to prevent clicking to fast on the buttons
const DELAY_BEFORE_ANSWER = 1.0
var answer_delay = 0.0


# Data stored during the scenario
var points_gained: int # Points gained during the scenario
var redo: bool # If the scenario must trigger again or not
var buildings_gained: Array


func _ready():
	# Load a dialogue by default
	start_dialog_event("res://scenarios/pedagogical/publier_donnees_transports.json")
	
	# Connect the timer to the correct method
	timer_display.connect("timeout", self, "_add_buttons")



# Instance is the script that contains functions
# and the variable declaration for Whiskers logic
func start_dialog_event(dialog_json, show_tutorial = false):
	# Show the mouse cursor if a tutorial
	if show_tutorial:
		$MouseCursor.show()
	
	# Hides the name by default
	$UI/Name.hide()
	
	# Reset the previous data
	redo = false
	points_gained = 0
	buildings_gained.clear()
	
	
	print("Opening " + dialog_json)
	
	# Get the script instance
	var instance = ScenariosData.get_scenario_instance(dialog_json)
	
	
	# create a parser
	parser = WhiskersParser.new(instance)
	
	# Get the dialogue data
	dialogue_data = parser.open_whiskers(dialog_json)
	
	# Get the first dialog bloc
	block = parser.start_dialogue(dialogue_data)
	
	# If it was not a block with data
	process_data_blocks()
		
	print(block.text)
	# Update the dialog
	update_dialog()



func _physics_process(delta):
	# Update the delay for the answers
	answer_delay += delta



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
	# Quit if not enought time passed
	if answer_delay < DELAY_BEFORE_ANSWER:
		pass
		
	# If this is the last block
	elif block.empty() or block.is_final:
		print("That was the last dialog !")
		emit_signal("dialog_finished")
		
	# If we don't expect a call from a button
	elif not expect_player_answer():
		# Change the Dialog
		block = parser.next("")
		
		# Play a soundy sound !
		sound_player.stream = sound_dialog_click
		sound_player.play()
		
		# Hide the mouse
		$MouseCursor.hide()
		
			
		# Process blocks with data
		process_data_blocks()
			
			
		update_dialog()
	


func player_pushed_button(key):
	# If enough time passed after the answers were displayed
	if answer_delay >= DELAY_BEFORE_ANSWER and not block.empty():
		# Switch to the next block
		block = parser.next(key)
		
		# If the dialog line was the last, an empty dic is returned
		if block.empty():
			emit_signal("dialog_finished")
			
		else:
			# Play the sound !
			sound_player.stream = sound_answer_click
			sound_player.play()
			
			# Process blocks with data
			process_data_blocks()
			
			# Display the next dialog if not finished
			if block.empty() or block.is_final:
				print("That was the last dialog !")
				emit_signal("dialog_finished")
			else:
				update_dialog()
	else:
		print("Not enough time passed")



func update_dialog():
	# Set the dialog line on the UI (if not a data block)
	if not is_data_block():
		dialog_line.text = block.text
	
	# Remove the old answer buttons
	var old_buttons = answer_container.get_children()
	for button in old_buttons:
		answer_container.remove_child(button)
	
	# Reset the answer delay
	answer_delay = 0.0
	
	# If there is a need for answer buttons
	if not block.options.empty():
		# Add the buttons after a delay
		timer_display.start(DELAY_BEFORE_DISPLAY)



func _add_buttons():
	# Add the new buttons
	for answer in block.options:
		# Instanciate
		var button = answer_button.instance()
		
		# Set text
		button.set_text(answer.text)
		
		# Button action
		button.connect("pressed", self, "player_pushed_button", [answer.key])

		
		# Add it to the container
		answer_container.add_child(button)
		
	# Reset the Answer delay
	answer_delay = 0.0
	print("Delay resetted")



func expect_player_answer() -> bool:
	return block.options.size() > 0



func set_dialog_background(fileName):
	# Get the path to the background texture
	var texture_path = "res://assets/sprites/backgrounds/"+fileName
	
	# If it exists, change it
	if ResourceLoader.exists(texture_path):		
		background_sprite.texture = load(texture_path)
	else:
		print("Unknown background texture " + texture_path)



func set_dialog_character(fileName):
	# Get the path to the character texture
	var texture_path = "res://assets/sprites/characters/"+fileName
	
	# If it exists, change it
	if ResourceLoader.exists(texture_path):
		character_sprite.texture = load(texture_path)
	else:
		print("Unknown character texture " + texture_path)



func set_character_name(name: String):
	#Show the Container
	$UI/Name.show()
	
	$UI/Name.text = name



func process_data_blocks():
	while process_single_data_block():
		print("Data block")
		print(block.text)
		
		# Leave the loop if last block
		if block.empty() or block.is_final:
			print("Last block")
			emit_signal("dialog_finished")
			break
			
		# Else it is not the last dialog : switch
		else:
			block = parser.next()



func is_data_block():
	# Check if there is a "=" in the block text
	return '=' in block.text



func process_single_data_block():
	# Get the block test
	var text = block.text
	
	if text.begins_with("background="):
		# Extract the file path
		var bg_path = text.substr("background=".length())
		
		set_dialog_background(bg_path)
		
		# The block contained data
		return true
		
	elif text.begins_with("character="):
		# Extract the file path
		var character_path = text.substr("character=".length())
		
		set_dialog_character(character_path)
		
		# The block contained data
		return true
		
	elif text.begins_with("name="):
		# Extract the file path
		var name = text.substr("name=".length())
		
		set_character_name(name)
		
		# The block contained data
		return true
		
	elif text.begins_with("datapoints="):
		# Extract the points
		var points = text.substr("datapoints=".length())
		
		# Cast points to int
		points = int(points)
		
		# Add points
		points_gained += points
		
		# The block contained data
		return true
	
	elif text.begins_with("redo="):
		# Extract the value
		var v = text.substr("redo=".length())
		
		if v == "false":
			redo = false
		elif v == "true":
			redo = true
		else:
			print("Unknown redo value : " + v)
			
		# The block contained data
		return true
	
	elif text.begins_with("building="):
		# Extract the building name
		var building = text.substr("building=".length())
		
		# Add it to the Array
		buildings_gained.append(building)
			
		# The block contained data
		return true
		
		
	# Else
	return false



func get_points_gained():
	return points_gained


func get_buildings_gained():
	return buildings_gained


# Return true if the dialog must occur again in the future
func must_redo_dialog():
	return redo
