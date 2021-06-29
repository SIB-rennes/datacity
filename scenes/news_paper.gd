extends Node2D

enum {
	WAITING_TO_ZOOM,
	ZOOMING,
	SHOWING_1
}

# Current state
var current_state = WAITING_TO_ZOOM


# Mouse cursor blinking
onready var mouse_cursor = $MouseCursor



# Variable for elapsed time
var elapsed_time : float


# Targets for position and scale
const TARGET_POS = Vector2(0, 0)
const TARGET_SCALE = Vector2(1.2, 1.2)
const TARGET_ROTATION = 0

# Variation speed
const ZOOM_TIME = 1.0


var starting_pos = Vector2.ZERO
var starting_scale = Vector2.ZERO
var starting_rotation = 0


func _on_NewsPaper_input_event(viewport, event, shape_idx):
	if current_state == WAITING_TO_ZOOM:
		# Zoom the newspapers if the player click on them
		if event is InputEventMouseButton:
			if event.pressed and event.position:
				trigger_zoom()
		elif event is InputEventScreenTouch:
			if event.pressed:
				trigger_zoom()


func _process(delta):
	elapsed_time += delta
	if current_state == ZOOMING:
		zoom()
	
	
func trigger_zoom():
	print("Zoom triggered")
	
	current_state = ZOOMING
	elapsed_time = 0
	
	# Save position, scale and rotation for interpolation
	starting_pos = position
	starting_scale = scale
	starting_rotation = rotation
	
	# Deactivates the mouse animation
	mouse_cursor.hide()
	
	
func zoom():
	# Animation weight
	var weight = min(1.0, elapsed_time / ZOOM_TIME)
	
	position = starting_pos.linear_interpolate(TARGET_POS, weight)
	scale = starting_scale.linear_interpolate(TARGET_SCALE, weight)
	rotation_degrees = lerp(rotation_degrees, TARGET_ROTATION, weight) #Linear interpolation for angle
