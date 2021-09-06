class_name Car
extends KinematicBody2D

const CAR_SPEED = 200
var boost
export var is_running = false
onready var path = get_parent()



# Called when the node enters the scene tree for the first time.
func _ready():
	is_running = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	boost = 1
	if (Input.is_action_pressed("speed_up")):
		boost = 2.2
	path.offset -= CAR_SPEED * boost * delta
