extends Control
class_name Historical

signal close_historical

var speaker_name = "nobody"

var historical_cooldown_option = false
var historical_message = preload("res://ui/historical_message.tscn")
onready var message_container = $VBoxContainer/ScrollMargin/ScrollContainer/message_container

func add_message(block):
	var message = historical_message.instance()
	message.update_message(block)
	message.update_name(speaker_name)
	message.set_h_size_flags(0)
	message_container.add_child(message)

func _on_exit_button_pressed():
	emit_signal("close_historical")

func reboot_historical():
	var message = historical_message.instance()
	for child in message_container.get_children():
		child.queue_free()

func historical_options(block):
	if historical_cooldown_option == false:
		print('test un deux test')
		var message = historical_message.instance()
		message.update_message(block)
		message.update_name("Maire")
		message.set_h_size_flags(8)
		message_container.add_child(message)
		historical_cooldown_option = true


func _on_ButtonA_historical_infos():
	historical_options(PlayerData.options_selected)
