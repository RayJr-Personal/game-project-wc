extends Node2D

var parent
var Car = preload("res://Car.tscn")
var current_car

func add_car():
	var lane_number = str(randi() % 5 + 1)
	print(lane_number)
	parent = get_node("Lane" + lane_number + "/PathFollow2D")
	current_car = Car.instance()
	parent.add_child(current_car)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	add_car()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(str(randi() % 5 + 1))
	if (parent.get_offset() == 0.0):
		add_car()
