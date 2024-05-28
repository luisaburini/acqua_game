extends CanvasLayer

signal pressed_sebo
signal pressed_morro
signal pressed_praca
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func change_map(map):
	$TextureRect.texture = load(map)

func _on_touch_morro_button_pressed():
	pressed_morro.emit()

func _on_touch_sebo_button_pressed():
	pressed_sebo.emit()

func _on_touch_praca_button_pressed():
		pressed_praca.emit()
