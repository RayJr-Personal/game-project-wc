class_name Car
extends KinematicBody2D

const CAR_SPEED = 350

# For signal
var is_boosting

# General variables
var collision
var multiplier
var player
var root

# For switching lanes
var lanes = [Vector2(1380, 240), Vector2(1380, 320), Vector2(1380, 400), Vector2(1380, 480), Vector2(1380, 570)]
var lane_nums
signal car_spawned


# Signals
func connect_signals():
	player.connect("boost_started", self, "_on_boost_started")
	player.connect("boost_stopped", self, "_on_boost_stopped")
	self.connect("car_spawned", root, "_on_car_spawned")
 
func _on_boost_started():
	is_boosting = true

func _on_boost_stopped():
	is_boosting = false



# Picks a random lane (co-ordinates) out of 5 for the car to spawn on
# If all lanes have just been used, car will wait
# If one lane has just been used, car will spawn in different lane
func new_lane():
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
		self.position = lanes[lane_number]




# Called when the node enters the scene tree for the first time.
func _ready():
	root = get_parent()
	
	lane_nums = root.lane_nums
	player = root.get_node("KinematicBody2D")
	connect_signals()
	new_lane()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	multiplier = 1
	if (is_boosting):
		multiplier = 2.2
	
	move_and_collide(Vector2(-1, 0) * CAR_SPEED * multiplier * delta)
	
	if (self.position.x < -50):
		new_lane()
	
