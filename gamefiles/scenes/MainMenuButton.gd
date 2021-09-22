extends Button

var tree

func change_scene(scene_name):
	tree.change_scene("res://scenes/" + scene_name + ".tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	tree = get_tree()

func _on_StartBtn_pressed():
	change_scene("level1")

func _on_ExitBtn_pressed():
	tree.quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
