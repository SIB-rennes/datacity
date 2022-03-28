extends MarginContainer

func update_message(block):
	var aff_message = $HBoxContainer/MarginContainer/background/MarginContainer/RichTextLabel
	print("block :", block)
	aff_message.set_text(block)

func update_name(speaker_name):
	if speaker_name == "Maire":
		var speaker = $HBoxContainer/VBoxContainer2/speaker
		speaker.set_text(speaker_name)
		$HBoxContainer/VBoxContainer2/speaker.show()
		$HBoxContainer/VBoxContainer/speaker.hide()
		$HBoxContainer/MarginContainer/background.flip_h = true
	else:
		var speaker = $HBoxContainer/VBoxContainer/speaker
		print("Speaker :", speaker_name)
		speaker.set_text(speaker_name)
		$HBoxContainer/VBoxContainer2/speaker.hide()
		$HBoxContainer/VBoxContainer/speaker.show()
		$HBoxContainer/MarginContainer/background.flip_h = false
