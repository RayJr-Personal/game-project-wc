class_name Car
extends KinematicBody2D

const CAR_SPEED = 350

# For signal
var is_boosting

# General variables
var collision
var speed_multiplier
var player
var root
var test
var flip_multiplier

# For switching lanes
var lanes = [Vector2(1380, 240), Vector2(1380, 320), Vector2(1380, 400), Vector2(1380, 480), Vector2(1380, 570)]
var lane_nums
signal car_spawned
 
# Checks whether the player has collided.

func collided(state):
	if (state != null and state.get_collider_id() == player.get_instance_id()):
		player.game_over = true
		root._on_game_over("You crashed!")


func flipper(level):
	if (level == 1):
		flip_multiplier = 1
	else:
		flip_multiplier = 2

# Signals
func connect_signals():
	player.connect("boost_started", self, "_on_boost_started")
	player.connect("boost_stopped", self, "_on_boost_stopped")
	root.connect("speed_changed", self, "_on_speed_change")
	self.connect("car_spawned", root, "_on_car_spawned")
 
func _on_boost_started():
	speed_multiplier = root.speed_multiplier

func _on_boost_stopped():
	speed_multiplier = root.speed_multiplier

func _on_speed_change():
	speed_multiplier = root.speed_multiplier
	print("Car speed changed!")
	print(speed_multiplier)


# Picks a random lane (co-ordinates) out of 5 for the car to spawn on
# If all lanes have just been used, car will wait
# If one lane has just been used, car will spawn in different lane
func new_lane():
	var effect_chance = randi() % 100 + 1
	if (lane_nums.size() == 0):
		var timer = Timer.new()
		timer.set_wait_time(2)
		timer.set_one_shot(true)
		self.add_child(timer)
		timer.start()
	else:
		var rand_index = (randi() % lane_nums.size()) - 1
		var lane_number = lane_nums[rand_index]
		emit_signal("car_spawned", lane_number)
		
		if (effect_chance < 100):
			self.position = lanes[lane_number]
		else:
			self.position.x = -50


func init_variables():
	root = get_parent()
	lane_nums = root.lane_nums
	player = root.get_node("KinematicBody2D")
	speed_multiplier = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	init_variables()
	connect_signals()
	new_lane()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	collided(move_and_collide(Vector2(-1, 0) * CAR_SPEED * speed_multiplier * flip_multiplier * delta))
	
	if (self.position.x <= -50):
		new_lane()
	
