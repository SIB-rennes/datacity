extends MarginContainer

signal close_no_datapoints

onready var text_label = $MainContainer/ScrollMargin/VBoxContainer/MarginContainer/RichTextLabel



#func _ready():
#	text_label.connect("meta_clicked", self, "_on_RichTextLabel_meta_clicked")
#
#
#
#func _on_RichTextLabel_meta_clicked(meta):
#	var err = OS.shell_open(meta)
#	if err == OK:
#		print("Opened link '%s' successfully!" % meta)
#	else:
#		print("Failed opening the link '%s'!" % meta)



func _on_Button_pressed():
	emit_signal("close_no_datapoints")
