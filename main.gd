extends Node

var locations = ["Sebo", "Praca", "Balneario"]
var current_location = 0					
signal reset_pos_esquerdo(pos)
signal reset_pos_direito(pos)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Fim.hide()
	$Dialogue.hide()
	$Player.hide()
	for loc in locations:
		var loc_node = get_node(loc)
		loc_node.hide()
	$CityMap.hide()
	$HUDMusic.play()
	$HUD.show()

func new_game():
	$Fim.hide()
	$Dialogue.hide()
	$HUDMusic.stop()
	$SeboMusic.play()
	$Praca.hide_all()
	$Balneario.hide_all()
	$Sebo.start()
	$HUD.show_message("")	
	$Player.start($StartPosition.position)

func get_current_location_node():
	var location = locations[current_location]
	print("Main: " + location)
	return get_node(location)
	
	

func _on_player_limite_direito():
	var loc = get_current_location_node()
	if not $Player.is_walking() and loc != null:
		loc.update_objs_state(+1)
		reset_pos_direito.emit(loc.get_start_position())


func _on_player_limite_esquerdo():
	var loc = get_current_location_node()
	if not $Player.is_walking() and loc != null:
		loc.update_objs_state(-1)
		reset_pos_esquerdo.emit(loc.get_return_position())


func _on_sebo_leave():
	$Sebo.hide()
	$CityMap.show()


func _on_sebo_stop_music():
	$SeboMusic.stop()


func _on_city_map_pressed_sebo():
	$CityMap.hide()
	$Sebo.show()
	current_location = 0


func _on_sebo_go_to_next_scene():
	_on_player_limite_direito()
	
func _on_sebo_go_back_scene():
	_on_player_limite_esquerdo()


func _on_city_map_pressed_praca():
	if $Sebo.is_completed():
		current_location = 1
		$CityMap.hide()
		$PracaMusic.play()
		$Praca.start()
		$Player.show()
		$Player.start($StartPosition.position)
	else:
		$Dialogue.change_label("Tem coisa para fazer no sebo! Volta lá!")
		$Dialogue.change_texture("res://img/sebo-detalhe.png")
		$Dialogue.start_hide_timer()
		$Dialogue.show()
		$Dialogue.hide_interaction()


func _on_praca_go_back_scene():
	_on_player_limite_esquerdo()


func _on_praca_go_to_next_scene():
	_on_player_limite_direito()


func _on_city_map_pressed_balneario():
	if $Praca.is_completed():
		$CityMap.hide()
		$BalnearioMusic.play()
		$Balneario.start()
		$Player.show()
		current_location = 2
		$Player.start($StartPosition.position)
	else:
		$Dialogue.change_label("Tem coisa para fazer na praça! Volta lá!")
		$Dialogue.change_texture("res://img/praca-adhemar-de-barros.jpg")
		$Dialogue.start_hide_timer()
		$Dialogue.show()
		$Dialogue.hide_interaction()


func _on_praca_leave():
	$Praca.hide()
	$CityMap.show()


func _on_balneario_go_back_scene():
	_on_player_limite_esquerdo()


func _on_balneario_go_to_next_scene():
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
	$Fim.show()
