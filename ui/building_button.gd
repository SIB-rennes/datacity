extends MarginContainer


signal selected_building




## Set the building display
## building_name is the displayed name of the building
## If the number left is -1, consider infinite
func set_building(building : String, left: int = PlayerData.INF_BUILDING):
	# check if there is a texture
	if not building in BuildingsData.TEXTURES:
		print("Can't find a texture for '" + building + "'")
		return
	
	# Set the button display
	$Building/BuildingContainer/BuildingSprite.texture = BuildingsData.TEXTURES.get(building)
	$Building/Name.text = building
	
	if left == PlayerData.INF_BUILDING:
		$Building/Left.text = ""
	else:
		$Building/Left.text = "Restant : " + String(left)
		
	
	# Set the building bonus
	set_building_bonus(building)



func set_building_bonus(building : String):
	var bonus = BuildingsData.get_building_bonus(building)
	
	# If there is a bonus
	if not bonus[0].empty():
		$Building/Bonus.text = bonus[0] + " +" + String(bonus[1])
	else:
		$Building/Bonus.text = ""


func _on_Button_pressed():
	emit_signal("selected_building")

