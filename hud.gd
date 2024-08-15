extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game
var started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().physics_object_picking_sort = true
	
func start():
	print("Started HUD")
	started = true
	show()
	
func end():
	print("Ended HUD")
	started = false
	hide_all()
	
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
	
	
func _unhandled_input(event):
	if event is InputEventScreenTouch and event.pressed == true:
		if started:
			get_viewport().set_input_as_handled()
