extends Node

var locations = ["Sebo", "Praca", "Balneario"]
var current_location = 0					

signal reset_pos_esquerdo(pos)
signal reset_pos_direito(pos)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.hide()
	$Dialogue.hide()
	$Sebo.hide()
	$Praca.hide()
	$CityMap.hide()
	$HUDMusic.play()
	$HUD.show()

func new_game():
	$HUDMusic.stop()
	$SeboMusic.play()
	$Praca.hide_all()
	$Sebo.start()
	$HUD.show_message("")	
	$Player.start($StartPosition.position)

func get_current_location_node():
	var location = locations[current_location]
	print(location)
	return get_node(location)
	
	

func _on_player_limite_direito():
	var loc = get_current_location_node()
	if not $Player.is_walking() and loc != null:
		loc.update_texture(+1)
		loc.update_objs_state()
		$Dialogue.hide()
		reset_pos_direito.emit(loc.get_start_position())


func _on_player_limite_esquerdo():
	var loc = get_current_location_node()
	if not $Player.is_walking() and loc != null:
		loc.update_texture(-1)
		loc.update_objs_state()
		$Dialogue.hide()
		reset_pos_esquerdo.emit(loc.get_return_position())

func _on_dialogue_pressed_yes():
	$Dialogue.hide()

func _on_dialogue_pressed_no():
	$Dialogue.hide()

func _on_sebo_leave():
	$Sebo.hide()
	$CityMap.show()
	current_location = current_location+1

func _on_sebo_cannot_leave():
	$Dialogue.change_texture("res://img/capybara-ismael.png")
	$Dialogue.change_label("Ainda tem coisa pra fazer aqui")
	$Sebo.hide_dialogue()
	$Dialogue.show()
	$Dialogue.hide_interaction()
	$Dialogue.start_hide_timer()


func _on_sebo_stop_music():
	$SeboMusic.stop()


func _on_sebo_will_show_dialogue():
	$Dialogue.hide()


func _on_city_map_pressed_sebo():
	$Dialogue.hide()
	$CityMap.hide()
	$Sebo.show()


func _on_sebo_go_to_next_scene():
	_on_player_limite_direito()
	
func _on_sebo_go_back_scene():
	_on_player_limite_esquerdo()


func _on_city_map_pressed_praca():
	$Dialogue.hide()
	if $Sebo.is_completed():
		$CityMap.hide()
		$PracaMusic.play()
		$Praca.start()
		$Player.show()
		$Player.start($StartPosition.position)


func _on_praca_go_back_scene():
	_on_player_limite_esquerdo()


func _on_praca_go_to_next_scene():
	_on_player_limite_direito()
