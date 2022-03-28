extends MarginContainer


onready var text_label = $MainContainer/ScrollMargin/VBoxContainer/MarginContainer/ScrollContainer2/RichTextLabel



func _ready():
	text_label.connect("meta_clicked", self, "_on_RichTextLabel_meta_clicked")
		


func _on_RichTextLabel_meta_clicked(meta):
	var err = OS.shell_open(meta)
	if err == OK:
		print("Opened link '%s' successfully!" % meta)
	else:
		print("Failed opening the link '%s'!" % meta)



func _on_Button_pressed():
	hide()
	get_tree().get_current_scene().get_node("buttons").show()

