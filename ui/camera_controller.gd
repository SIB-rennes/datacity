extends Camera2D


func _input(event):
	# If the mouse moved and the button was pressed
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("move_camera"):
			# Move the camera position
			position += event.relative * -1
	
	
	elif Input.is_action_just_released("wheel_down") and zoom.x < 2:
		zoom.x += 0.1
		zoom.y += 0.1
	elif Input.is_action_just_released("wheel_up") and zoom.x > .6:
		zoom.x -= 0.1
		zoom.y -= 0.1

