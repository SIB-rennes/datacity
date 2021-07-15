extends MarginContainer


func set_text(text: String):
	$VBoxContainer/Label.text = text


# Value from 0 to 100
func set_percentage(percentage: int):
	$VBoxContainer/TextureProgress.value = percentage
