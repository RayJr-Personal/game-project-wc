class_name Effect
extends KinematicBody2D

const MOVE_SPEED = 350

var lanes = [Vector2(1380, 240), Vector2(1380, 320), Vector2(1380, 400), Vector2(1380, 480), Vector2(1380, 570)]
var lane_nums

var effect_type
var speed_multiplier
var flip_multiplier
var player
var root
var level
var spawn_delay


func pick_type():
	var type = randi() % 3
	
	match type:
		0: # Extra Boost effect
			effect_type = "boost"
			get_node("boost").visible = true
	
		1: # Slow Down effect
			effect_type = "slow"
			get_node("slow").visible = true
	
		2: # Extra Time effect
			effect_type = "time"
			get_node("time").visible = true


func new_lane():
	if (lane_nums.size() != 0):
		var rand_index = (randi() % lane_nums.size()) - 1
		var lane_number = lane_nums[rand_index]
		self.position = lanes[lane_number]
	var timer = spawn_delay
	timer.start()
	yield(timer, "timeout")


func collided(state):
	if (state != null and state.get_collider_id() == player.get_instance_id()):
		root._on_effect_pickup(effect_type)
		player._on_effect_pickup(effect_type)
		self.queue_free()


func check_level():
	match level:
		1:
			flip_multiplier = 1
		2:
			flip_multiplier = 2

# Boosting
func _on_boost_started():
	speed_multiplier = 2.2

func _on_boost_stopped():
	speed_multiplier = 1


# All starting variable inits here.
func init_variables():
	speed_multiplier = 1
	flip_multiplier = 1
	root = get_parent()
	level = int(root.get_name()[-1])
	player = root.get_node("KinematicBody2D")
	lane_nums = root.lane_nums
	spawn_delay = get_node("Timer")


# All signals here.
func connect_signals():
	player.connect("boost_started", self, "_on_boost_started")
	player.connect("boost_stopped", self, "_on_boost_stopped")


# Called when the node enters the scene tree for the first time.
func _ready():
	init_variables()
	connect_signals()
	check_level()
	pick_type()
	new_lane()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	collided(move_and_collide(Vector2(-1, 0) * MOVE_SPEED * speed_multiplier * flip_multiplier * delta))
	
	if (self.position.x < -50):
		self.queue_free()
	
