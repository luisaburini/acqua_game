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
	print("City Map starting")
	started = true
	$CityMapMusic.play()
	show_button(location, locations)
	show()
	
	
func end():
	print("CityMap ended")
	started = false
	$CityMapMusic.stop()
	hide()

func _on_touch_sebo_button_pressed():
	get_viewport().set_input_as_handled()
	$CityMapMusic.stop()
	pressed_sebo.emit()

func _on_touch_praca_button_pressed():
	get_viewport().set_input_as_handled()
	$CityMapMusic.stop()
	pressed_praca.emit()

func _on_touch_balneario_button_pressed():
	get_viewport().set_input_as_handled()
	$CityMapMusic.stop()
	pressed_balneario.emit()

func _unhandled_input(event):
	if event is InputEventScreenTouch and event.pressed == true:
		if started:
			get_viewport().set_input_as_handled()


func _on_city_map_music_finished():
	$CityMapMusic.play()


func show_button(showing, locations):
	for loc in locations:
		var button = get_node("Touch"+loc+"Button")
		var label = get_node(loc+"Label")
		if loc == showing:
			button.show()
			label.show()
		else:
			label.hide()
			button.hide()
