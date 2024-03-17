extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureRect.hide()
	$Player.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func new_game():
	$Music.play()
	$TextureRect.show()
	$Player.show()
	$Player.start($StartPosition.position)
	$HUD.show_message("")	

