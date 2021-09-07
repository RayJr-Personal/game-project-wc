extends Node2D

const CAR_COUNT = 10

var Car = preload("res://Car.tscn")
var car1 = preload("res://resources/cars/spr_bluecar_0.png")
var car2 = preload("res://resources/cars/spr_camper_0.png")
var car3 = preload("res://resources/cars/spr_estatecar_0.png")
var car4 = preload("res://resources/cars/spr_rally_0.png")
var car5 = preload("res://resources/cars/spr_silvercar_0.png")
var car6 = preload("res://resources/cars/spr_van_0.png")

var cars = [car1, car2, car3, car4, car5, car6]

func add_car():
	for i in range(0, CAR_COUNT):
		
		var cs = Sprite.new()
		var car_type = randi() % 5
		cs.texture = cars[car_type]
		cs.scale = Vector2(0.500, 0.500)
		
		var ci = Car.instance()
		ci.add_child(cs)
		
		var timer = Timer.new()
		timer.set_wait_time(0.75)
		timer.set_one_shot(true)
		self.add_child(timer)
		timer.start()
		yield(timer, "timeout")
		
		var path_follow = PathFollow2D.new()
		path_follow.add_child(ci)
		
		var lane_number = str(randi() % 5 + 1)
		var parent = get_node("Lane" + lane_number)
		parent.add_child(path_follow)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	add_car()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
