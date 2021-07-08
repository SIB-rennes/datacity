extends MarginContainer


signal selected_building


const FILES = {
	"Maison 1": "res://assets/sprites/buildings/house_1.png",
	"Maison 2": "res://assets/sprites/buildings/house_2.png",
	"Maison 3": "res://assets/sprites/buildings/house_3.png",
	"Mairie": "res://assets/sprites/buildings/city_hall.png",
	"Hôpital": "res://assets/sprites/buildings/hospital.png",
	"Commissariat": "res://assets/sprites/buildings/police_department.png"
}


## Set the building display
## building_name is the displayed name of the building
func set_building(building : String, left : int):
	# check if there is a texture
	if not building in FILES:
		print("Can't find a texture for the building")
		return
	
	# Set the button display
	$Building/BuildingSprite.texture = load(FILES.get(building))
	$Building/Name.text = building
	$Building/Left.text = "Restant : " + String(left)



func _on_Button_pressed():
	emit_signal("selected_building")

