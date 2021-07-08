extends MarginContainer
class_name CityUI

# Custom signals
signal open_notifications
signal open_guide
signal open_settings
signal open_build
signal logout
signal cancel_build



# References to the UI Elements
onready var population = $VBoxContainer/TopContainer/TopLeftContainer/Population
onready var datapoints = $VBoxContainer/TopContainer/TopLeftContainer/DataPoints


## Sets the population label
func set_population(pop: int):
	population.set_text("Population | " + String(pop))


## Sets the population label
func set_datapoints(points: int):
	datapoints.set_text("Datapoints | " + String(points))



func show_current_building(texture: Texture):
	# Hide the Build button
	$VBoxContainer/BottomContainer/BuildButton.hide()
	
	# Show the Cancel Contaienr
	$VBoxContainer/BottomContainer/CancelContainer.show()
	
	# Set the button texture 
	$VBoxContainer/BottomContainer/CancelContainer/MarginContainer/HBoxContainer/BuildingSprite.texture = texture
	


func show_build_button():
	# Sho the Build button
	$VBoxContainer/BottomContainer/BuildButton.show()


#==========> Signal Senders <==========#

func _on_NotificationButton_pressed():
	emit_signal("open_notifications")


func _on_HighScoreButton_pressed():
	emit_signal("open_scores")


func _on_SettingsButton_pressed():
	emit_signal("open_settings")


func _on_LogoutButton_pressed():
	emit_signal("logout")


func _on_BuildButton_pressed():
	emit_signal("open_build")


func _on_GuideButton_pressed():
	emit_signal("open_guide")


func _on_CancelBuildButton_pressed():
	emit_signal("cancel_build")
