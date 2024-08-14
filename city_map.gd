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

func start(location, locations):
	$CityMapMusic.play()
	show_button(location, locations)
	show()
	
func end():
	$CityMapMusic.stop()
	hide()

func _on_touch_sebo_button_pressed():
	$CityMapMusic.stop()
	pressed_sebo.emit()

func _on_touch_praca_button_pressed():
	$CityMapMusic.stop()
	pressed_praca.emit()

func _on_touch_balneario_button_pressed():
	$CityMapMusic.stop()
	pressed_balneario.emit()


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
