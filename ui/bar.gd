extends MarginContainer


func set_text(text: String):
	$VBoxContainer/Label.text = text


# Value from 0 to 100
func set_percentage(percentage: int):
	$VBoxContainer/TextureProgress.value = percentage
	
	
	## Color
	#var color
	#
	# Red to Yellow
	#if percentage <= 50: 
	#	color = Color.red.linear_interpolate(Color.yellow, percentage/50.0)
	#else: # Yellow to Green
	#	color = Color.yellow.linear_interpolate(Color.green, (percentage-50)/50.0)
	#	
	#$VBoxContainer/TextureProgress.tint_progress = color
