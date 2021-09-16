extends Node2D

const CAR_COUNT = 7
# 140 km / 60 minutes / 60 seconds
const KM_PER_SECOND = 0.03888888888

var speed_multiplier = 1

var Car = preload("res://Car.tscn")
var car1 = preload("res://resources/cars/spr_bluecar_0.png")
var car2 = preload("res://resources/cars/spr_camper_0.png")
var car3 = preload("res://resources/cars/spr_estatecar_0.png")
var car4 = preload("res://resources/cars/spr_rally_0.png")
var car5 = preload("res://resources/cars/spr_silvercar_0.png")
var car6 = preload("res://resources/cars/spr_van_0.png")

var cars = [car1, car2, car3, car4, car5, car6]
var lane_nums = [0, 1, 2, 3, 4]

var distance_count = 5 # kilometres
onready var distance_left_text = get_node("DistanceLeft")
onready var distance_left_timer = get_node("DistanceLeft/Timer")
onready var time_left_text = get_node("TimeLeft")
onready var time_left_timer = get_node("TimeLeft/Timer")
onready var countdown_text = get_node("CountdownText")
onready var countdown_timer = get_node("CountdownText/Timer")
onready var effect_text = get_node("EffectText")
onready var effect_timer = get_node("EffectText/Timer")

onready var player = get_node("KinematicBody2D")

# Adds a car into the current scene. A random sprite is given to the car.
# There is also a 0.75 second delay between spawning cars.
func add_cars():
	for _i in range(0, CAR_COUNT):
		
		var cs = Sprite.new()
		var car_type = randi() % 6
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

func spawn_effect():
	var spawn_chance = (randi() % 100)
	if (spawn_chance > 90)
	

# Called by a timer on timeout. Removes a lane from the list of lanes
# to signify that that lane has just been spawned on and cannot be used.
# A delay of 1 second occurs until that lane is re-added to th list again.
func _on_car_spawned(lane_num):
	lane_nums.erase(lane_num)
	
	var timer = Timer.new()
	timer.connect("timeout", self, "re_add_lane_num", [lane_num])
	timer.set_wait_time(1)
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.start()


# Called by the timer from _on_car_spawned().
# Adds a lane to the list of lanes.
func re_add_lane_num(lane_num):
	lane_nums.append(lane_num)


# Countdown timer for when the level starts.
func countdown():
	if (countdown_timer.time_left > 0):
		countdown_text.set_text(str(int(countdown_timer.time_left)+1))
	else:
		countdown_text.visible = false


func distance_left(delta):
	distance_left_text.set_text("Distance left: " + str(int(distance_count)) + "km")
	distance_count -= (delta * KM_PER_SECOND * speed_multiplier)


func time_left():
	time_left_text.set_text("Time left: " + str(int(time_left_timer.time_left)))


func check_player_win():
	if (distance_count <= 0 and time_left_timer.time_left > 1):
		_on_game_over("You win!")
	elif (time_left_timer.time_left == 0 and distance_count > 0):
		_on_game_over("Too late.")


func _on_boost_started():
	speed_multiplier = 2.2


func _on_boost_stopped():
	speed_multiplier = 1


func _on_game_over(msg):
	effect_text.visible = true
	effect_text.set_text(msg + " Game Over")
	effect_timer.start()
	yield(effect_timer, "timeout")
	effect_text.visible = false


# Called when the node enters the scene tree for the first time.
func _ready():
	effect_text.visible = false
	countdown_timer.start()
	yield(countdown_timer, "timeout")
	
	player.connect("boost_started", self, "_on_boost_started")
	player.connect("boost_stopped", self, "_on_boost_stopped")
	player.connect("game_over_signal", self, "_on_game_over")
	
	time_left_timer.start()
	randomize()
	add_cars()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	countdown()
	
	if (countdown_timer.is_stopped()):
		time_left()
		distance_left(delta)
		check_player_win()
