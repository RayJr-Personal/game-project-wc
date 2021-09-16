extends Sprite

# the length at which the road will reset to its original position once
# it goes past this limit to simulate scrolling
const ROAD_REPEAT_X = -167

# (in pixels) width of white line + gap between 2 white lines
const SCROLL_SPEED = 16.7

var player
var speed_multiplier = 0.75
var roadPosition = Vector2()

func _on_boost_started():
	speed_multiplier = 2.2

func _on_boost_stopped():
	speed_multiplier = 0.75

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("KinematicBody2D")
	player.connect("boost_started", self, "_on_boost_started")
	player.connect("boost_stopped", self, "_on_boost_stopped")
	roadPosition = get_offset()

func _process(delta):
	
	roadPosition.x -= (SCROLL_SPEED * speed_multiplier)
	if (roadPosition.x <= ROAD_REPEAT_X):
		roadPosition.x = 0
	
	set_offset(roadPosition)
