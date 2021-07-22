extends MarginContainer


signal close_results


# Preload the Building buttons
var building_button = preload("res://ui/building_button.tscn")

# Building button container
onready var building_container = $ScrollMargin/VBoxContainer/ScrollContainer/BuildingContainer



func hide():
	# Remove each building button
	for child in building_container.get_children():
		building_container.remove_child(child)
	
	.hide()



func set_points_gained(points: int):
	# No points => no text
	if points == 0:
		$ScrollMargin/VBoxContainer/PointsGained.text = ""
		return
	
	# Create the text
	var text = "Datapoints "
	
	if points > 0:
		text += "+"
	else:
		text += "-"
	
	text += String(points)
	
	# Set the text
	$ScrollMargin/VBoxContainer/PointsGained.text = text



## Adds a building button
## building_name is the displayed name of the building
func add_building(building_name: String):
	var button = building_button.instance()
	button.set_building(building_name)
	
	# Add as a child
	building_container.add_child(button)



func _on_QuitButton_pressed():
	emit_signal("close_results")
