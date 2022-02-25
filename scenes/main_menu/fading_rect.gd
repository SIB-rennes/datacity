extends ColorRect

signal fade_finished

func fade_in():
	get_parent().show()
	# Start fading
	$AnimationPlayer.play("Fading")
	
	# Play the starting sound
	$SoundPlayer.play()


func _on_AnimationPlayer_animation_finished(_anim_name):
	emit_signal("fade_finished")
	get_parent().hide()
