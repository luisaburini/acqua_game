extends Node

var locations = ["Sebo", "Praca", "Balneario"]
var current_location = 0					

# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().physics_object_picking_sort = true
	$Fim.hide()
	$Player.end()
	for loc in locations:
		var loc_node = get_node(loc)
		loc_node.hide()
		loc_node.reset()
	$HUDMusic.play()
	$HUD.start()

func new_game():
	$Player.end()
	for loc in locations:
		var loc_node = get_node(loc)
		loc_node.hide_all()
	$Fim.hide()
	$HUD.end()
	$CityMap.start(locations[current_location], locations)

func get_current_location_node():
	var location = locations[current_location]
	return get_node(location)
	

func _on_player_limite_direito():
	var loc = get_current_location_node()
	if loc != null:
		loc.update_objs_state(+1)
		$Player.end()
		$Player.start(loc.get_start_position())
		$Player.flip_horizontal(true)
		


func _on_player_limite_esquerdo():
	var loc = get_current_location_node()
	if loc != null:
		loc.update_objs_state(-1)
		$Player.end()
		$Player.start(loc.get_start_position())


func _on_sebo_leave():
	$Player.end()
	$Sebo.end()
	$SeboMusic.stop()
	current_location = 1
	$HUDMusic.play()
	$CityMap.start(locations[current_location], locations)


func _on_sebo_stop_music():
	$SeboMusic.stop()


func _on_city_map_pressed_sebo():
	$CityMap.end()
	$HUDMusic.stop()
	$SeboMusic.play()
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
		$HUDMusic.stop()
		$SeboMusic.stop()
		$PracaMusic.play()
		$Player.start($PracaPosition.position)
		$Player.flip_horizontal(true)
		$Praca.start()

func _on_praca_go_back_scene():
	_on_player_limite_esquerdo()


func _on_praca_go_to_next_scene():
	_on_player_limite_direito()


func _on_city_map_pressed_balneario():
	if $Praca.is_completed():
		$CityMap.end()
		$HUDMusic.stop()
		current_location = 2
		$BalnearioMusic.play()
		$Player.start($BalnearioPosition.position)
		$Player.flip_horizontal(true)
		$Balneario.start()


func _on_praca_leave():
	$Player.end()
	$Praca.end()
	$PracaMusic.stop()
	current_location = 2
	$HUDMusic.play()
	$CityMap.start(locations[current_location], locations)


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


var started_fim = false

func _on_balneario_leave():
	for loc in locations:
		var loc_node = get_node(loc)
		loc_node.hide_all()
	$BalnearioMusic.stop()
	$Balneario.end()
	$Fim.show()
	started_fim = true
	$FimMusic.play()
	$EtMusic.play()


func _on_reset_pressed():
	started_fim = false
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
		if !$CityMap.started and !$HUD.started:
			if $Sebo.started or $Praca.started or $Balneario.started or started_fim:
				get_viewport().set_input_as_handled()
				$Player.walk_to(event.position)
				


func _on_sebo_player_go_to(pos):
	if $Sebo.started:
		$Player.walk_to(pos)


func _on_praca_player_go_to(pos):
	if $Praca.started:
		$Player.walk_to(pos)


func _on_balneario_player_go_to(pos):
	if $Balneario.started:
		$Player.walk_to(pos)
