extends Camera2D

const ZOOM_SPEED = 0.5
const ZOOM_MIN = 10
const ZOOM_MAX = 2

const DRAG_SPEED = 5


func _unhandled_input(event):
	# If the mouse moved and the button was pressed
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("move_camera"):
			# Move the camera position
			position -= event.relative * DRAG_SPEED
	
	
	elif Input.is_action_just_released("wheel_down"):
		zoom.x = min(ZOOM_MIN, zoom.x + ZOOM_SPEED)
		zoom.y = min(ZOOM_MIN, zoom.y + ZOOM_SPEED)
	elif Input.is_action_just_released("wheel_up"):
		zoom.x = max(ZOOM_MAX, zoom.x - ZOOM_SPEED)
		zoom.y = max(ZOOM_MAX, zoom.y - ZOOM_SPEED)

