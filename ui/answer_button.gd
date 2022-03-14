extends Button

signal historical_infos

func set_text(text: String):
	$VBoxContainer/Label.text = text


func _on_ButtonA_pressed():
	PlayerData.options_selected = $VBoxContainer/Label.text
	emit_signal("historical_infos")
