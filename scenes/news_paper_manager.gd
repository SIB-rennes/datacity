extends Node2D

signal start_fade


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

# Sound Player
onready var sound_player = $SoundPlayer

# Mouse cursor blinking
onready var mouse_cursor = $MouseCursor

# Newspapers
onready var newspaper = [$Newspaper_1, $Newspaper_2, $Newspaper_3]

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




func _input(event):
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
					if elapsed_time >= PAUSE_TIME:
						show_next_newspaper()



func _process(delta):
	elapsed_time += delta



func trigger_zoom():
	# Play the animation
	$ZoomPlayer.play("PaperZoom")
	
	print("Playing zoom !")
	
	# Deactivates the mouse animation
	mouse_cursor.hide()
	
	# Play a sound !
	sound_player.play()



func _on_ZoomPlayer_animation_finished(_anim_name):
	current_state = SHOWING_1
	


func show_next_newspaper():
	# Reset elapsed time
	elapsed_time = 0.0
	
	# Play a sound !
	sound_player.play()
	
	match current_state:
		SHOWING_1:
			current_state = SHOWING_2
			
			# Hide 1
			newspaper[0].animate()
			
		SHOWING_2:
			current_state = SHOWING_3
			
			# Hide 2
			newspaper[1].animate()
			
		SHOWING_3:
			current_state = STARTING_DIALOG
			
			# Zoom on the third
			newspaper[2].animate()
			
			# Fading screen to dialogue
			emit_signal("start_fade")
			

