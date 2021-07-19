extends MarginContainer

signal close_guide

onready var text_label = $MainContainer/ScrollMargin/VBoxContainer/MarginContainer/ScrollContainer2/RichTextLabel

func _ready():
	# If not a web export, connect urls to OS shell open
	if OS.get_name() != "HTML5":
		text_label.connect("meta_clicked", self, "_on_RichTextLabel_meta_clicked")
		


func _on_RichTextLabel_meta_clicked(meta):
	var err = OS.shell_open(meta)
	if err == OK:
		print("Opened link '%s' successfully!" % meta)
	else:
		print("Failed opening the link '%s'!" % meta)


func _on_QuitButton_pressed():
	emit_signal("close_guide")
	
	# reset the scrolling
	text_label.scroll_to_line(0)
