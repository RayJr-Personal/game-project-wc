extends Sprite

# the length at which the road will reset to its original position once
# it goes past this limit to simulate scrolling
const ROAD_REPEAT_X = -167

# (in pixels) width of white line + gap between 2 white lines
const SCROLL_SPEED = 16.7

var speed_multiplier
var boost = 100
var roadPosition = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	roadPosition = get_offset()

func _process(delta):
	speed_multiplier = 0.75
	 
	if (Input.is_action_pressed("speed_up") and boost >= 0):
		speed_multiplier = 2.2
		boost -= delta*50
	
	roadPosition.x -= (SCROLL_SPEED * speed_multiplier)
	if (roadPosition.x <= ROAD_REPEAT_X):
		roadPosition.x = 0
	
	set_offset(roadPosition)
