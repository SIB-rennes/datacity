extends MarginContainer


signal selected_building
 
var result_aff = false
var building_set = false
var limit_var = 0
var left_var = 0


func _process(delta):
	if building_set == true and result_aff == false:
		if limit_var == left_var:
			get_node(".").modulate = Color(606060)
## Set the building display
## building_name is the displayed name of the building
## If the number left is -1, consider infinite
func set_building(building : String, left: int = PlayerData.INF_BUILDING, count = ""):
	# check if there is a texture
	if not building in BuildingsData.TEXTURES:
		print("Can't find a texture for '" + building + "'")
		return
	
	# Set the button display
	$Building/BuildingContainer/BuildingSprite.texture = BuildingsData.TEXTURES.get(building)
	
	if result_aff == false:
		$Building/Name.text = building
	elif result_aff == true:
		$Building/Name.text = building
	
	if result_aff == false:
		if left == PlayerData.INF_BUILDING:
			$Building/Left.text = ""
		else:
			$Building/Left.text = "Limite : " + String(left - 1)+ "/" + String(PlayerData.building_limit[building] - 1)
			limit_var = PlayerData.building_limit[building] - 1
			left_var = left - 1
	if result_aff == true:
		$Building/Left.text = " Limite + " + String(count)
		
		
	building_set = true
	
	# Set the building bonus
	set_building_bonus(building)
	set_building_prix(building)


func set_building_bonus(building : String):
	var bonus = BuildingsData.get_building_bonus(building)
	
	# If there is a bonus
	if not bonus[0].empty():
		$Building/Bonus.text = bonus[0] + " +" + String(bonus[1])
	else:
		$Building/Bonus.text = ""

func set_building_prix(building : String):
	var prix = BuildingsData.get_buildings_price(building)
	$Building/Prix.text = str("Prix: ", + BuildingsData.PRIX[building], " Datapoints")

func _on_Button_pressed():
	if not limit_var == left_var:
		emit_signal("selected_building")

