extends KinematicBody2D

const MOVE_SPEED = 300
var boost = 100

# General variables
var extents
var screensize
var direction
var game_over = false

# Labels
var label_boost

# Signals
signal boost_started
signal boost_stopped
signal game_over_signal


# Checks whether the player has collided
func collided(state):
	if (state != null):
		game_over = true
		emit_signal("game_over_signal", "You crashed!")


# Called when the node enters the scene tree for the first time.
func _ready():
	label_boost = get_parent().get_node("BoostText")
	
	screensize = get_viewport_rect().size
	extents = get_node("Player").get_texture().get_size() / 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _physics_process(delta):
	var input = Vector2()
	if (game_over == false):
		input.x += int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
		input.y += int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
		self.position.x = clamp(self.position.x, extents.x - 50, screensize.x - extents.x/2 - 25)
		self.position.y = clamp(self.position.y, 190 + extents.y, screensize.y - extents.y/2)
	else:
		input = Vector2(-1, 0)
		
	direction = input.normalized()
	collided(move_and_collide(direction * MOVE_SPEED * delta))
	
	
	if (Input.is_action_pressed("speed_up") and boost >= 0):
		boost -= delta*50
		label_boost.text = "Boost: " + str(int(boost)) 
		emit_signal("boost_started")
		if (boost <= 0):
			emit_signal("boost_stopped")
	if (Input.is_action_just_released("speed_up") and boost >= 0):
		emit_signal("boost_stopped")
