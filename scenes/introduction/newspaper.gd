extends Sprite

# The animation player
onready var animation_player = $Animation

func animate():
	animation_player.play("put_back")
