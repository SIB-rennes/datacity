extends MarginContainer
class_name CityUI

# Custom signals
signal open_notifications
signal close_notifications
signal start_dialog
signal open_guide
signal open_settings
signal open_build
signal logout
signal cancel_build
signal unvalidate_position
signal validate_position
signal closed_tutorial


## References to the UI Elements
onready var population = $VBoxContainer/TopContainer/TopLeftContainer/Points/Population
onready var datapoints = $VBoxContainer/TopContainer/TopLeftContainer/Points/DataPoints
onready var confirmation_dialog = $VBoxContainer/ConfirmationDialog

# Bars
onready var bar_satisfaction = $VBoxContainer/TopContainer/TopLeftContainer/NeedContainer/Satisfaction

func _ready():
	# Hides the UI elements until the Tutorial is closed
	$VBoxContainer.hide()
	
	# Connect the Confirmation Dialog
	confirmation_dialog.get_cancel().connect("pressed", self, "_unvalidate_pressed")
	confirmation_dialog.get_ok().connect("pressed", self, "_validate_pressed")
	confirmation_dialog.get_ok().focus_mode = FOCUS_NONE # Unfocus the OK button
	confirmation_dialog.get_cancel().focus_mode = FOCUS_NONE # Unfocus the OK button
	
	# Hides the close button
	confirmation_dialog.get_close_button().hide()


## Sets the population label
func set_population(pop: int, pop_max: int):
	# Population string
	var pop_str = String(pop)
	if pop == 0:
		pop_str = "-"
		
	# Max Population string
	var pop_max_str = String(pop_max)
	if pop_max == 0:
		pop_max_str = "-"
	
	population.set_text(pop_str + " / " + pop_max_str)


## Sets the population label
func set_datapoints(points: int):
	datapoints.set_text(String(points))



func update_bars():
	# Player max population
	var max_pop = PlayerData.city_data[PlayerData.POPULATION_MAX]
	
	if max_pop == 0:
		return
	
	# Satisfaction
	var satisfaction_percent = (50.0 * PlayerData.city_data[PlayerData.SATISFACTION]) / max_pop
	bar_satisfaction.set_percentage(satisfaction_percent)

func show_current_building(building: String):
	# Hide the Build button
	$VBoxContainer/BottomContainer/BuildButton.hide()
	
	# Show the Cancel Contaienr
	$VBoxContainer/BottomContainer/CancelContainer.show()
	
	# Set the button texture 
	if building in BuildingsData.TEXTURES:
		var texture = BuildingsData.TEXTURES.get(building)
		$VBoxContainer/BottomContainer/CancelContainer/MarginContainer/Background/BuildingSprite.texture = texture
	else:
		print("No texture for the current building " + building)


func show_build_button():
	# Sho the Build button
	$VBoxContainer/BottomContainer/BuildButton.show()
	
	# Hide the Cancel Contaienr
	$VBoxContainer/BottomContainer/CancelContainer.hide()



func show_validation_popup():
	confirmation_dialog.popup()



func display_notification():
	#Show the active icon
	$VBoxContainer/TopContainer/TopLeftContainer/NotificationButtonActive.show()
	$VBoxContainer/TopContainer/TopLeftContainer/NotificationButton.hide()
	
	$VBoxContainer/TopContainer/TopLeftContainer/NotificationPlayer.play()



func show_notifications(text: String):
	# Set the Notification text
	$VBoxContainer/TopContainer/TopLeftContainer/EventMessage.set_string(text)
	
	# Show it
	$VBoxContainer/TopContainer/TopLeftContainer/EventMessage.show()
	
	#Hides the buttons
	$VBoxContainer/TopContainer/TopLeftContainer/NotificationButtonActive.hide()
	$VBoxContainer/TopContainer/TopLeftContainer/NotificationButton.hide()


# Has event is true if there is still an event in the notifications
func close_notifications(has_event: bool):
	# Hides the notifications details
	$VBoxContainer/TopContainer/TopLeftContainer/EventMessage.hide()
	
	# Show the button 
	if has_event:
		$VBoxContainer/TopContainer/TopLeftContainer/NotificationButtonActive.show()
	else:
		$VBoxContainer/TopContainer/TopLeftContainer/NotificationButton.show()
	


func close_tutorial():
	# Removes the tutorial
	$TutorialCity.queue_free()
	
	# Execute as if the user had closed it
	_on_TutorialCity_close_tutorial()

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



func _validate_pressed():
	emit_signal("validate_position")


func _unvalidate_pressed():
	emit_signal("unvalidate_position")


func _on_EventMessage_close_notification():
	emit_signal("close_notifications")


func _on_EventMessage_start_dialogue():
	emit_signal("start_dialog")


func _on_TutorialCity_close_tutorial():
	# Show the UI
	$VBoxContainer.show()
	
	emit_signal("closed_tutorial")
