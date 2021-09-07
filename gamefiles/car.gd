class_name Car
extends KinematicBody2D

const CAR_SPEED = 350
var boost
export var is_running = false
onready var path = get_parent()



# Called when the node enters the scene tree for the first time.
func _ready():
	is_running = true
	path.unit_offset = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	boost = 1
	if (Input.is_action_pressed("speed_up")):
		boost = 2.2
	path.offset -= CAR_SPEED * boost * delta
	if (path.unit_offset < 0.01):
		
		var old_lane = path.get_parent()
		old_lane.remove_child(path)
		var root = old_lane.get_parent()
		
		var lane_number = str(randi() % 5 + 1)
		var new_lane = root.get_node("Lane" + lane_number)
		new_lane.add_child(path)
		
		path.unit_offset = 1
		print("here")
