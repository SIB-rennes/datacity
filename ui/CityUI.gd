extends MarginContainer
class_name CityUI

# Custom signals
signal open_notifications
signal open_scores
signal open_settings
signal open_build
signal logout



# References to the UI Elements
onready var population = $VBoxContainer/TopContainer/TopLeftContainer/Population
onready var datapoints = $VBoxContainer/TopContainer/TopLeftContainer/DataPoints


## Sets the population label
func set_population(pop: int):
	population.set_text("Population | " + String(pop))


## Sets the population label
func set_datapoints(points: int):
	datapoints.set_text("Datapoints | " + String(points))



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
