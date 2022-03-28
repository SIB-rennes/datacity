extends Camera2D



const ZOOM_SPEED = 0.5
const ZOOM_MIN = 1
const ZOOM_MAX = 13
var zoom_sensitivity = 20

var events = {}
var last_drag_distance = 0

var block_cam: bool

func block_camera(block: bool):
	block_cam = block 

func _input(event):
	if not block_cam:
		# Touch Manager
		if event is InputEventScreenTouch:
			if event.pressed:
				events[event.index] = event
			else:
				events.erase(event.index)
		if event is InputEventScreenDrag:
			events[event.index] = event
			if events.size() == 1:
				position -= event.relative * zoom.x
				clamp_position()
			if events.size() == 2:
				var drag_distance = events[0].position.distance_to(events[1].position)
				if abs(drag_distance - last_drag_distance) > zoom_sensitivity:
					if drag_distance < last_drag_distance:
						zoom.x = max(ZOOM_MIN, zoom.x - ZOOM_SPEED)
						zoom.y = max(ZOOM_MIN, zoom.y - ZOOM_SPEED)
					else:
						zoom.x = min(ZOOM_MAX, zoom.x + ZOOM_SPEED)
						zoom.y = min(ZOOM_MAX, zoom.y + ZOOM_SPEED)
					last_drag_distance = drag_distance
		# If the mouse moved and the button was pressed
		if event is InputEventMouseMotion and not event is InputEventScreenTouch:
				if Input.is_action_pressed("move_camera"):
				# Move the camera position
					position -= event.relative * zoom.x
					clamp_position()
		elif Input.is_action_just_released("wheel_down"):
			zoom.x = min(ZOOM_MAX, zoom.x + ZOOM_SPEED)
			zoom.y = min(ZOOM_MAX, zoom.y + ZOOM_SPEED)
		elif Input.is_action_just_released("wheel_up"):
			zoom.x = max(ZOOM_MIN, zoom.x - ZOOM_SPEED)
			zoom.y = max(ZOOM_MIN, zoom.y - ZOOM_SPEED)

func clamp_position():
	var left = limit_left + (offset.x*zoom.x) + get_viewport_rect().size.x * zoom.x / 2
	var right = limit_right - (offset.x*zoom.x) - get_viewport_rect().size.x * zoom.x / 2
	var top = limit_top + (offset.y*zoom.y) + get_viewport_rect().size.y * zoom.y / 2
	var bottom = limit_bottom - (offset.y*zoom.y) - get_viewport_rect().size.y * zoom.y / 2
	position.x = clamp(position.x, left, right)
	position.y = clamp(position.y, top, bottom)

