extends Control

var new_game = false
var dir = Directory.new()
var os = OS.get_name()
onready var confirmation_new_game = $confirmation_new_game
onready var credit_button = $buttons/CreditButton

func _ready():
	$PhoneInfos.show()
	$buttons.hide()
	

func on_fade_finished():
	if new_game == true:
		dir.remove("user://savegame.save")
		PlayerData.save_found = false
	# If a save file was found, try to load it
	if File.new().file_exists(PlayerData.SAVEFILE):
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scenes/CityBuilder.tscn")
		PlayerData.save_found = true
	else:
		print("No save found")


		PlayerData.must_load_save = false
		PlayerData.save_found = false
		# If no save was found
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scenes/Introduction.tscn")



func _on_SkipIntro_pressed():
	# Do not load the save if there is not
	if not File.new().file_exists(PlayerData.SAVEFILE):
		PlayerData.must_load_save = false
	
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/CityBuilder.tscn")


func _on_PhoneInfos_next_button_pressed():
	$PhoneInfos.hide()
	$buttons.show()



func _on_New_game_pressed():
	$buttons.hide()
	confirmation_new_game.show()


func _on_confirmation_new_game_No_its_a_mistake():
	$buttons.show()
	confirmation_new_game.hide()


func _on_CreditButton_pressed():
	$Credits.show()
	$buttons.hide()
