extends Node2D

enum {
	WAITING_TO_ZOOM,
	ZOOMING,
	SHOWING_1,
	SHOWING_2,
	SHOWING_3,
	STARTING_DIALOG
}

# Current state
var current_state = WAITING_TO_ZOOM


# Mouse cursor blinking
onready var mouse_cursor = $MouseCursor

# Newspapers
onready var newspaper = [$newspaper_1, $newspaper_2, $newspaper_3]

# Variable for elapsed time
var elapsed_time : float


# Targets for position and scale
const TARGET_POS = Vector2(0, 0)
const TARGET_SCALE = Vector2(1.2, 1.2)
const TARGET_ROTATION = 0

# Variation speed
const ZOOM_TIME = 1.0

# Pause before allowing to switch newspapers
const PAUSE_TIME = 3.0


var starting_pos = Vector2.ZERO
var starting_scale = Vector2.ZERO
var starting_rotation = 0


func _on_NewsPaper_input_event(viewport, event, shape_idx):
	# If mouse pressed
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			# Switch to the next newspaper
			match current_state:
			# Zoom the newspapers if the player click on them
				WAITING_TO_ZOOM:
					trigger_zoom()
				
				# Switch to next newspaper
				SHOWING_1, SHOWING_2, SHOWING_3:
					print("Click !")
					if elapsed_time >= PAUSE_TIME:
						show_next_newspaper()



func _process(delta):
	elapsed_time += delta
	match current_state:
		ZOOMING:
			zoom()
			
			# Once the zoom animation is done, switch state
			if elapsed_time >= ZOOM_TIME:
				current_state = SHOWING_1
		
		
	
	
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



func show_next_newspaper():
	# Reset elapsed time
	elapsed_time = 0.0
	
	match current_state:
		SHOWING_1:
			current_state = SHOWING_2
			
			# Hide 1
			newspaper[0].hide()
			
		SHOWING_2:
			current_state = SHOWING_3
			
			# Hide 2
			newspaper[1].hide()
			
		SHOWING_3:
			current_state = STARTING_DIALOG
			
			# Hide 2
			newspaper[2].hide()
			
