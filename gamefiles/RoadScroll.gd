extends Sprite

# (in pixels) width of white line + gap between 2 white lines
const SCROLL_SPEED = 16.7

var speed_multiplier
var boost = 2.2
var roadPosition = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	roadPosition = get_offset()

func _process(delta):
	speed_multiplier = 0.75 
	if (Input.is_action_pressed("speed_up")):
		speed_multiplier = speed_multiplier * boost
	roadPosition.x -= (SCROLL_SPEED * speed_multiplier)
	if (roadPosition.x <= -167):
		roadPosition.x = 0
	set_offset(roadPosition)
	pass
