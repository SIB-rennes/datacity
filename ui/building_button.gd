extends MarginContainer


signal selected_building




## Set the building display
## building_name is the displayed name of the building
func set_building(building : String, left : int):
	# check if there is a texture
	if not building in BuildingsData.TEXTURES:
		print("Can't find a texture for the building" + building)
		return
	
	# Set the button display
	$Building/BuildingSprite.texture = BuildingsData.TEXTURES.get(building)
	$Building/Name.text = building
	$Building/Left.text = "Restant : " + String(left)



func _on_Button_pressed():
	emit_signal("selected_building")

