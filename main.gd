extends Node

var locations = ["Sebo", "Praca", "Balneario"]
var current_location = 0					

# Called when the node enters the scene tree for the first time.
func _ready():
	$Fim.hide()
	$Dialogue.hide()
	$Player.hide()
	for loc in locations:
		var loc_node = get_node(loc)
		loc_node.hide()
		loc_node.reset()
	$HUDMusic.play()
	$HUD.show()

func new_game():
	$Fim.hide()
	$Dialogue.hide()
	$HUDMusic.stop()
	$HUD.hide()
	$Sebo.hide_all()
	$Praca.hide_all()
	$Balneario.hide_all()
	$CityMap.start(locations[current_location], locations)

func get_current_location_node():
	var location = locations[current_location]
	print("Main: get_current location node " + location)
	return get_node(location)
	
	

func _on_player_limite_direito():
	var loc = get_current_location_node()
	if loc != null:
		loc.update_objs_state(+1)
		$Player.go_to(loc.get_start_position())


func _on_player_limite_esquerdo():
	var loc = get_current_location_node()
	if loc != null:
		loc.update_objs_state(-1)
		$Player.go_to(loc.get_start_position())


func _on_sebo_leave():
	$Sebo.end()
	$SeboMusic.stop()
	current_location = 1
	print(locations[current_location])
	$CityMap.start(locations[current_location], locations)


func _on_sebo_stop_music():
	$SeboMusic.stop()


func _on_city_map_pressed_sebo():
	$CityMap.end()
	$Sebo.start()
	$Player.start($SeboPosition.position)


func _on_sebo_go_to_next_scene():
	_on_player_limite_direito()
	
func _on_sebo_go_back_scene():
	_on_player_limite_esquerdo()


func _on_city_map_pressed_praca():
	if $Sebo.is_completed():
		current_location = 1
		$CityMap.end()
		$PracaMusic.play()
		$Player.start($PracaPosition.position)
		$Praca.start()
	else:
		$Dialogue.change_label("Tem coisa para fazer no sebo! Volta lá!")
		$Dialogue.change_texture("res://img/sebo-detalhe.png")
		$Dialogue.start_hide_timer()
		$Dialogue.show()
		$Dialogue.hide_interaction()

func _on_praca_go_back_scene():
	print("On praca go back scene")
	_on_player_limite_esquerdo()


func _on_praca_go_to_next_scene():
	print("On praca go next scene")
	_on_player_limite_direito()


func _on_city_map_pressed_balneario():
	if $Praca.is_completed():
		$CityMap.end()
		current_location = 2
		$BalnearioMusic.play()
		$Player.start($BalnearioPosition.position)
		$Balneario.start()
	else:
		$Dialogue.change_label("Tem coisa para fazer na praça! Volta lá!")
		$Dialogue.change_texture("res://img/praca-adhemar-de-barros.jpg")
		$Dialogue.start_hide_timer()
		$Dialogue.show()
		$Dialogue.hide_interaction()

func _on_praca_leave():
	print("PRACA LEAVE")
	$Praca.end()
	$PracaMusic.stop()
	current_location = 2
	$CityMap.start(locations[current_location], locations)


func _on_balneario_go_back_scene():
	print("Balneario go back scene")
	_on_player_limite_esquerdo()


func _on_balneario_go_to_next_scene():
	print("Balneario go to next scene")
	_on_player_limite_direito()


func _on_sebo_music_finished():
	$SeboMusic.play()


func _on_praca_music_finished():
	$PracaMusic.play()


func _on_hud_music_finished():
	$HUDMusic.play()


func _on_balneario_music_finished():
	$BalnearioMusic.play()


func _on_balneario_leave():
	$Balneario.hide_all()
	$Praca.hide_all()
	$Sebo.hide_all()
	$BalnearioMusic.stop()
	$Fim.show()
	$FimMusic.play()
	$EtMusic.play()


func _on_reset_pressed():
	current_location = 0	
	$SeboMusic.stop()
	$PracaMusic.stop()
	$BalnearioMusic.stop()
	$HUDMusic.stop()
	$FimMusic.stop()
	$EtMusic.stop()
	_ready()
	new_game()
		


func _on_sebo_audiodica_finished():
	$SeboMusic.play()


func _unhandled_input(event):
	if event is InputEventScreenTouch and event.pressed == true:
		$Player.walk_to(event.position)
