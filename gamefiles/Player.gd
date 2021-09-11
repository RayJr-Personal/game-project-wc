extends KinematicBody2D

const MOVE_SPEED = 300
var boost = 100

# General variables
var extents
var screensize

# Labels
var label_boost

# Signals
signal boost_started
signal boost_stopped

# Called when the node enters the scene tree for the first time.
func _ready():
	label_boost = get_parent().get_node("Label")
	
	screensize = get_viewport_rect().size
	extents = get_node("Player").get_texture().get_size() / 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.position.x = clamp(self.position.x, extents.x - 50, screensize.x - extents.x/2 - 25)
	self.position.y = clamp(self.position.y, 190 + extents.y, screensize.y - extents.y/2)

func _physics_process(delta):
	var input = Vector2()
	input.x += int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input.y += int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	var direction = input.normalized()
	move_and_collide(direction * MOVE_SPEED * delta)
	
	if (Input.is_action_pressed("speed_up") and boost >= 0):
		boost -= delta*50
		label_boost.text = "Boost: " + str(int(boost)) 
		emit_signal("boost_started")
		if (boost <= 0):
			emit_signal("boost_stopped")
	if (Input.is_action_just_released("speed_up") and boost >= 0):
		emit_signal("boost_stopped")
