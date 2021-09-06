extends KinematicBody2D

const MOVE_SPEED = 300

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var input = Vector2()
	input.x += int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	input.y += int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	var direction = input.normalized()
	move_and_collide(direction * MOVE_SPEED * delta)
