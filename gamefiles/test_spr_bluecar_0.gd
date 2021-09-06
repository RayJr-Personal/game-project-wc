extends KinematicBody2D

const CAR_SPEED = 200
var time = 0.0
onready var path = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#time += delta
	path.offset += CAR_SPEED * delta
