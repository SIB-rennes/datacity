extends MarginContainer
class_name NewCityUI

# Custom signals
signal open_notifications
signal close_notifications
signal start_dialog
signal open_guide
signal open_settings
signal open_build
signal logout
signal cancel_build
signal closed_tutorial

signal unvalidate_position
signal validate_position

signal cancel_hover
signal stop_cancel_hover

signal destroy_button_pressed
signal validate_destruction

## References to the UI Elements
onready var population = $Panel/Panel/BottomContainer/HBoxBottomContainer/HBoxContainer/PopulationContainer/Population
onready var datapoints = $Panel/Panel/BottomContainer/HBoxBottomContainer/HBoxContainer/DataPointsContainer/DataPoints
onready var confirmation_dialog = $Panel/ConfirmationDialog
onready var notification_button = $Panel/Panel/EventContainer/NotificationButton
onready var event_message = $Panel/EventMessage
onready var build_button = $Panel/Panel/MarginBuild/HBoxContainer/BuildContainer/BuildButton
# Bars
onready var bar_satisfaction = $Panel/Panel2/Satisfaction

onready var confirmation_container = $Panel/ConfirmationContainer

var texture_inactiv = preload("res://assets/sprites/interface/elements/Adjointe_icone_16032022.png")
var texture_activ = preload("res://assets/sprites/interface/elements/Adjointe_icone_notification_2_15032022.png")

var activ_notif = false

func _ready():
	# Hides the UI elements until the Tutorial is closed
	$Panel.hide()
	
	# Connect the Confirmation Dialog
	confirmation_dialog.get_cancel().connect("pressed", self, "_unvalidate_pressed")
	confirmation_dialog.get_ok().connect("pressed", self, "_validate_pressed")
	confirmation_dialog.get_ok().focus_mode = FOCUS_NONE # Unfocus the OK button
	confirmation_dialog.get_cancel().focus_mode = FOCUS_NONE # Unfocus the OK button
	
	# Hides the close button
	confirmation_dialog.get_close_button().hide()
	print("...")

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

func update_bars():
	# Player max population
	var max_pop = PlayerData.city_data[PlayerData.POPULATION_MAX]
	
	if max_pop == 0:
		return
	
	# Satisfaction
	var satisfaction_percent = (50.0 * PlayerData.city_data[PlayerData.SATISFACTION]) / max_pop
	bar_satisfaction.set_percentage(satisfaction_percent)

## Sets the population label
func set_datapoints(points: int):
	datapoints.set_text(String(points))
	datapoints.set_incomes(str("+ ", PlayerData.incomes, "/s"))



func update_build_buttonrs():
	# Player max population
	var max_pop = PlayerData.city_data[PlayerData.POPULATION_MAX]
	
	if max_pop == 0:
		return
	
	# Satisfaction
	var satisfaction_percent = (50.0 * PlayerData.city_data[PlayerData.SATISFACTION]) / max_pop
	bar_satisfaction.set_percentage(satisfaction_percent)

func show_current_building(building: String):
	# Hide the Build button
	build_button.hide()
	
	# Show the Cancel Button
	$Panel/Panel/MarginBuild/HBoxContainer/BuildContainer/CancelButton.show()



func show_build_button():
	# Show the Build button
	build_button.show()
	
	# Hide the Cancel Button
	$Panel/Panel/MarginBuild/HBoxContainer/BuildContainer/CancelButton.hide()


func display_notification():
	activ_notif = true
	
	notification_button.texture_normal = texture_activ
	
	$Panel/Panel/EventContainer/NotificationPlayer.play()


func show_notifications(text: String):
	# Set the Notification text
	event_message.set_string(text)
	
	# Show it
	event_message.show()


# Has event is true if there is still an event in the notifications
func close_notifications(has_event: bool):
	# Hides the notifications details
	event_message.set_deferred("visible", false)
	
	# Show the button 
	if has_event:
		activ_notif = true
		notification_button.texture_normal = texture_activ
	else:
		activ_notif = false
		notification_button.texture_normal = texture_inactiv
	

func show_validation_buttons():
	var pos_mouse = get_global_mouse_position()
	pos_mouse.x -= 70
	pos_mouse.y -= 100
	confirmation_container.set_position(pos_mouse)
	confirmation_container.show()


func close_tutorial():
	# Removes the tutorial
	$Panel/TutorialCity.queue_free()
	
	# Execute as if the user had closed it
	_on_TutorialCity_close_tutorial()


func show_cancel_button():
	# Hide the Build button
	build_button.hide()
	
	# Show the Cancel Button
	$Panel/Panel/MarginBuild/HBoxContainer/BuildContainer/CancelButton.show()

#==========> Signal Senders <==========#

func _on_NotificationButton_pressed():
	if activ_notif == true:
#		get_parent().get_node("dialog_tuto").hide()
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


func _on_EventMessage_close_notification():
	emit_signal("close_notifications")


func _on_EventMessage_start_dialogue():
	emit_signal("start_dialog")


func _on_TutorialCity_close_tutorial():
	# Show the UI
	$Panel.show()
	
	emit_signal("closed_tutorial")


func _on_CancelButton_pressed():
	emit_signal("cancel_build")


func _on_ValidateButton_pressed():
	emit_signal("validate_position")
	emit_signal("validate_destruction")


func _on_UnvalidateButton_pressed():
	emit_signal("unvalidate_position")


func _on_CancelButton_mouse_entered():
	emit_signal("cancel_hover")


func _on_CancelButton_mouse_exited():
	emit_signal("stop_cancel_hover")


func _on_DestroyButton_pressed():
	emit_signal("destroy_button_pressed")
