extends Node2D


func _ready():
	# create a parser
	var parser = WhiskersParser.new()
	
	# Get the dialogue data
	var dialogue_data = parser.open_whiskers("res://scenarios/dialog_intro.json")
	
	# Get the first dialog bloc
	var block = parser.start_dialogue(dialogue_data)
	
	while not block.is_final:
	
		print(block.text)
		print(block.options)
		
		if block.options.size() > 1:
			block = parser.next(block.options[1].key)
		else:
			block = parser.next("")
			
	# Last print as it is the last block
	print(block.text)
