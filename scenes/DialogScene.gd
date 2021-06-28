extends Node2D

# A Reference to the Dialog label
onready var dialog_line = $UI/TextPanel/DialogLine

# The background sprite
onready var background_sprite = $Background


# The container for the answer buttons
onready var answer_container = $UI/AnswerContainer

# Preload the button model
var answer_button = preload("res://ui/answer_button.tscn")


# Sound
onready var sound_player = $SoundPlayer
var sound_dialog_click = preload("res://assets/sounds/clic_dialog.wav")



# Storing parser, data and block for the dialog parsing
var parser
var dialogue_data
var block


# Answer delay, to prevent clicking to fast on the buttons
const DELAY_BEFORE_ANSWER = 1
var answer_delay = 0.0


func _ready():
	# Load a dialogue by default
	start_dialog_event("scenarios/dialog_conference.json")


func start_dialog_event(dialog_json):
	# create a parser
	parser = WhiskersParser.new()
	
	# Get the dialogue data
	dialogue_data = parser.open_whiskers(dialog_json)
	
	# Get the first dialog bloc
	block = parser.start_dialogue(dialogue_data)
	
	# Set the background, contained in the first dialogue node
	set_dialog_background()
	
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
	#If this is the last block
	if block.is_final:
		print("That was the last dialog !")
		
	# If we don't expect a call from a button
	elif not expect_player_answer():
		# Change the Dialog
		block = parser.next("")
		
		# Play a soundy sound !
		sound_player.stream = sound_dialog_click
		sound_player.play()
			
		update_dialog()
	


func player_pushed_button(key):
	# If enough time passed after the answers were displayed
	if answer_delay >= DELAY_BEFORE_ANSWER:
		block = parser.next(key)
		
		update_dialog()
	else:
		print("Not enough time passed")



func update_dialog():
	# Set the dialog line on the UI
	dialog_line.text = block.text
	
	# Remove the old answer buttons
	var old_buttons = answer_container.get_children()
	for button in old_buttons:
		answer_container.remove_child(button)
		
	# Add the new buttons
	for answer in block.options:
		# Instanciate
		var button = answer_button.instance()
		
		# Set text
		button.text = answer.text
		
		# Button action
		button.connect("pressed", self, "player_pushed_button", [answer.key])

		
		# Add it to the container
		answer_container.add_child(button)
		
	# Reset the Answer delay
	answer_delay = 0.0
	print("Delay resetted")



func expect_player_answer() -> bool:
	return block.options.size() > 0



func set_dialog_background():
	# Get the path to the background texture
	var texture_path = "res://assets/sprites/backgrounds/"+block.text
	
	# If it exists, change it
	if ResourceLoader.exists(texture_path):
		background_sprite.texture = load(texture_path)
		
		# Switch to the next (true first) dialogue
		block = parser.next("")
		update_dialog()
	else:
		print("Unknown background picture " + texture_path)
