extends Node2D


# 140 km / 60 minutes / 60 seconds
var km_per_second = 0.03888888888

var car_count = 7
var speed_multiplier = 1
var level
var won
var lost
var is_flip = false

var Effect = preload("res://scenes/effect.tscn")

var Car = preload("res://scenes/Car.tscn")
var car1 = preload("res://resources/cars/spr_bluecar_0.png")
var car2 = preload("res://resources/cars/spr_camper_0.png")
var car3 = preload("res://resources/cars/spr_estatecar_0.png")
var car4 = preload("res://resources/cars/spr_rally_0.png")
var car5 = preload("res://resources/cars/spr_silvercar_0.png")
var car6 = preload("res://resources/cars/spr_van_0.png")

var cars = [car1, car2, car3, car4, car5, car6]
var lane_nums = [0, 1, 2, 3, 4]

var distance_count # kilometres
onready var distance_left_text = get_node("DistanceLeft")
onready var distance_left_timer = get_node("DistanceLeft/Timer")
onready var time_left_text = get_node("TimeLeft")
onready var time_left_timer = get_node("TimeLeft/Timer")
onready var countdown_text = get_node("CountdownText")
onready var countdown_timer = get_node("CountdownText/Timer")
onready var effect_text = get_node("EffectText")
onready var effect_timer = get_node("EffectText/Timer")
onready var effect_spawn_timer = get_node("EffectSpawnTimer")

onready var player = get_node("KinematicBody2D")

signal speed_changed

# Adds a car into the current scene. A random sprite is given to the car.
# There is also a 0.75 second delay between spawning cars.
func add_cars():
	for _i in range(0, car_count):
		
		var cs = Sprite.new()
		var car_type = randi() % 6
		cs.texture = cars[car_type]
		cs.scale = Vector2(0.500, 0.500)
		cs.set_flip_h(is_flip)
		
		var ci = Car.instance()
		ci.flipper(level)
		ci.add_child(cs)
		
		add_child(ci)
		
		# delay
		var timer = Timer.new()
		timer.set_wait_time(0.75)
		timer.set_one_shot(true)
		self.add_child(timer)
		timer.start()
		yield(timer, "timeout")
		if (timer.is_stopped()):
			timer.queue_free()

func spawn_effect():
	var spawn_chance = (randi() % 100)
	if (spawn_chance > 90 and effect_spawn_timer.is_stopped()):
		var new_effect = Effect.instance()
		self.add_child(new_effect)
		effect_spawn_timer.start()
		yield(effect_spawn_timer, "timeout")


func _on_effect_spawned():
	spawn_effect()


func _on_effect_pickup(effect_type):
	match effect_type:
		"boost":
			effect_msg("Boost filled!") # see Player.gd
		"slow":
			speed_multiplier = 0.75
			emit_signal("speed_changed")
			effect_msg("Slow down!")
			
			var timer = Timer.new()
			timer.set_wait_time(5)
			timer.set_one_shot(true)
			self.add_child(timer)
			timer.start()
			yield(timer, "timeout")
			if (timer.is_stopped()):
				timer.queue_free()
			
			speed_multiplier = 1
			emit_signal("speed_changed")
		"time":
			time_left_timer.set_paused(true)
			effect_msg("Extra time!")
			
			var timer = Timer.new()
			timer.set_wait_time(5)
			timer.set_one_shot(true)
			self.add_child(timer)
			timer.start()
			yield(timer, "timeout")
			if (timer.is_stopped()):
				timer.queue_free()
			
			time_left_timer.set_paused(false)


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
	if (timer.is_stopped()):
		timer.queue_free()


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
	distance_left_text.set_text("Distance left: " + str(stepify(distance_count, 0.01)) + "km")
	distance_count -= (delta * km_per_second * speed_multiplier)


func time_left():
	time_left_text.set_text("Time left: " + str(int(time_left_timer.time_left)))


func check_player_win():
	won = distance_count <= 0 and time_left_timer.time_left > 1
	lost = time_left_timer.time_left == 0 and distance_count > 0
	if (won):
		if (level == 1):
			_on_game_over("You win!\nNext level...")
		if (level == 2):
			_on_game_over("You win!\nGame Over")
	elif (lost):
		_on_game_over("Too late...")


func effect_msg(msg):
	effect_text.visible = true
	effect_text.set_text(msg)
	effect_timer.start()
	yield(effect_timer, "timeout")
	effect_text.visible = false

func _on_boost_started():
	speed_multiplier = 2.2


func _on_boost_stopped():
	speed_multiplier = 1


func _on_game_over(msg):
	km_per_second = 0
	time_left_timer.set_paused(true)
	player.game_over = true
	effect_msg(msg)
	
	var timer = Timer.new()
	timer.set_wait_time(5)
	timer.set_one_shot(true)
	self.add_child(timer)
	timer.start()
	yield(timer, "timeout")
	if (timer.is_stopped()):
		timer.queue_free()
	
	if (won and level == 1):
		level = 2
		is_flip = true
		get_tree().change_scene("res://scenes/level2.tscn")
	else:
		level = 1
		is_flip = false
		get_tree().change_scene("res://scenes/GameOver.tscn")


func limit_window_size():
	OS.min_window_size = Vector2(1024, 600)
	OS.max_window_size = Vector2(1024, 600)


func connect_signals():
	player.connect("boost_started", self, "_on_boost_started")
	player.connect("boost_stopped", self, "_on_boost_stopped")


# Changes parameters depending on the level.
func level_modifier():
	match level:
		1:
			car_count = 7
			distance_count = 5
			time_left_timer.set_wait_time(120)
			is_flip = false
		2:
			car_count = 5
			distance_count = 2
			time_left_timer.set_wait_time(60)
			is_flip = true

# Called when the node enters the scene tree for the first time.
func _ready():
	level = int(self.get_name()[-1])
	effect_text.visible = false
	countdown_timer.start()
	yield(countdown_timer, "timeout")
	
	connect_signals()
	level_modifier()
	
	time_left_timer.start()
	randomize()
	add_cars()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	countdown()
	limit_window_size()
	
	if (countdown_timer.is_stopped()):
		time_left()
		distance_left(delta)
		check_player_win()
		spawn_effect()
