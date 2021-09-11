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
var lane_nums = [0, 1, 2, 3, 4]

# Adds a car into the current scene. A random sprite is given to the car.
# There is also a 0.75 second delay between spawning cars.
# MUST ADD FEATURE HERE THAT PREVENTS SPAWNING A CAR INTO ANOTHER CAR
func add_car():
	for i in range(0, CAR_COUNT):
		
		var cs = Sprite.new()
		var car_type = randi() % 5
		cs.texture = cars[car_type]
		cs.scale = Vector2(0.500, 0.500)
		
		var ci = Car.instance()
		ci.add_child(cs)
		
		add_child(ci)
		
		# delay
		var timer = Timer.new()
		timer.set_wait_time(0.75)
		timer.set_one_shot(true)
		self.add_child(timer)
		timer.start()
		yield(timer, "timeout")

func _on_car_spawned(lane_num):
	lane_nums.erase(lane_num)
	print(lane_nums)
	
	var timer = Timer.new()
	timer.connect("timeout", self, "re_add_lane_num", [lane_num])
	timer.set_wait_time(1)
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.start()

func re_add_lane_num(lane_num):
	lane_nums.append(lane_num)


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	add_car()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
