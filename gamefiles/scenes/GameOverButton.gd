extends Button


func change_scene(scene_name):
	get_tree().change_scene("res://scenes/" + scene_name + ".tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_TryAgainBtn_pressed():
	change_scene("level1")

func _on_MainMenuBtn_pressed():
	change_scene("MainMenu")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
