extends CanvasLayer

signal pressed_sebo
signal pressed_praca
signal pressed_balneario

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_touch_sebo_button_pressed():
	pressed_sebo.emit()

func _on_touch_praca_button_pressed():
	pressed_praca.emit()

func _on_touch_balneario_button_pressed():
	pressed_balneario.emit()
