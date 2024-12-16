extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game
var started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().physics_object_picking_sort = true
	
func start():
	started = true
	show()
	
func end():
	started = false
	hide_all()
	
func hide_all():
	$TextureRect.hide()
	$StartButton.hide()
	hide()

func _on_touch_screen_button_pressed():
	$StartButton.hide()
	$TextureRect.hide()
	start_game.emit()
	
	
func _unhandled_input(event):
	if event is InputEventScreenTouch and event.pressed == true:
		if started:
			get_viewport().set_input_as_handled()
