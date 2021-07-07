extends MarginContainer
class_name BuildMenu


signal exited_build_menu
signal selected_building(building_name)



# Preload the Building buttons
var building_button = preload("res://ui/building_button.tscn")

# Building button container
onready var building_container = $ScrollMargin/VBoxContainer/ScrollContainer/BuildingContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	add_building("Mairie", 1)
	add_building("Maison 1", 4)
	add_building("Maison 2", 2)
	add_building("Maison 3", 42)
	add_building("Hôpital", 1)
	add_building("Commissariat", 1)


## Adds a building button
## building_name is the displayed name of the building
func add_building(building_name: String, left: int):
	var button = building_button.instance()
	button.set_building(building_name, left)
	
	# Add as a child
	building_container.add_child(button)
	
	# Connect
	# The button will send this 4th parameter whenever it is pressed
	button.connect("selected_building", self, "_on_selected_building", [building_name])


func _on_selected_building(building_name):
	print("Selected : " + building_name)
	emit_signal("selected_building", building_name)


func _on_QuitButton_pressed():
	emit_signal("exited_build_menu")
