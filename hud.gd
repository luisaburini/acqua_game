extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	
func hide_all():
	$Message.hide()
	$TextureRect.hide()
	$StartButton.hide()
	$Label.hide()
	hide()

func _on_touch_screen_button_pressed():
	$StartButton.hide()
	$TextureRect.hide()
	$Label.hide()
	start_game.emit()
