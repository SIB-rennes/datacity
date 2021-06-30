extends Control

# Sound player
onready var sound_player = $SoundPlayer


func on_fade_finished():
	get_tree().change_scene("res://scenes/Introduction.tscn")
