extends ColorRect

signal fade_finished

func fade_in():
	# Start fading
	$AnimationPlayer.play("Fading")
	
	# Play the starting sound
	$SoundPlayer.play()


func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("fade_finished")
