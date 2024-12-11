extends CanvasLayer

signal pressed_sebo
signal pressed_praca
signal pressed_balneario

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
var started = false

func start(location, locations):
	started = true
	show_button(location, locations)
	show()
	
	
func end():
	started = false
	hide()

func _on_touch_sebo_button_pressed():
	get_viewport().set_input_as_handled()
	pressed_sebo.emit()

func _on_touch_praca_button_pressed():
	get_viewport().set_input_as_handled()
	pressed_praca.emit()

func _on_touch_balneario_button_pressed():
	get_viewport().set_input_as_handled()
	pressed_balneario.emit()

func _unhandled_input(event):
	if event is InputEventScreenTouch and event.pressed == true:
		if started:
			get_viewport().set_input_as_handled()


func show_button(showing, locations):
	for loc in locations:
		var button = get_node("Touch"+loc+"Button")
		var background = "res://img/mapa/"+loc+".png"
		if loc == showing:
			button.show()
			$TextureRect.texture = load(background)
		else:
			button.hide()
