extends Control


func on_fade_finished():
	get_tree().change_scene("res://scenes/Introduction.tscn")


func _on_SkipIntro_pressed():
	get_tree().change_scene("res://scenes/CityBuilder.tscn")
