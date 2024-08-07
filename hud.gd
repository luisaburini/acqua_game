extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Fim")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Acqua Game!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	

func _on_message_timer_timeout():
	$Message.hide()

func _on_touch_screen_button_pressed():
	$StartButton.hide()
	$TextureRect.hide()
	start_game.emit()
