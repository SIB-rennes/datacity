extends Control


func on_fade_finished():
	# If a save file was found, try to load it
	if File.new().file_exists(PlayerData.SAVEFILE):
		get_tree().change_scene("res://scenes/CityBuilder.tscn")
	else:
		print("No save found")
		
		PlayerData.must_load_save = false
		
		# If no save was found
		get_tree().change_scene("res://scenes/formulaire.tscn")


func _on_SkipIntro_pressed():
	# Do not load the save if there is not
	if not File.new().file_exists(PlayerData.SAVEFILE):
		PlayerData.must_load_save = false
	
	get_tree().change_scene("res://scenes/CityBuilder.tscn")
