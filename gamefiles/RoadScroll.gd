extends Sprite

# the length at which the road will reset to its original position once
# it goes past this limit to simulate scrolling
const ROAD_REPEAT_X = -167

# (in pixels) width of white line + gap between 2 white lines
const SCROLL_SPEED = 16.7

var root
var player
var speed_multiplier
var roadPosition = Vector2()

func _on_boost_started():
	speed_multiplier = root.speed_multiplier - 0.25

func _on_boost_stopped():
	speed_multiplier = root.speed_multiplier - 0.25


func init_variables():
	root = get_parent()
	player = root.get_node("KinematicBody2D")
	speed_multiplier = root.speed_multiplier - 0.25
	roadPosition = get_offset()


func connect_signals():
	player.connect("boost_started", self, "_on_boost_started")
	player.connect("boost_stopped", self, "_on_boost_stopped")
	root.connect("speed_changed", self, "_on_speed_changed")


func _on_speed_changed():
	speed_multiplier = root.speed_multiplier - 0.25


# Called when the node enters the scene tree for the first time.
func _ready():
	init_variables()
	connect_signals()

func _process(_delta):
	#speed_multiplier = root.speed_multiplier - 0.25
	
	roadPosition.x -= (SCROLL_SPEED * speed_multiplier)
	if (roadPosition.x <= ROAD_REPEAT_X):
		roadPosition.x = 0
	
	set_offset(roadPosition)
