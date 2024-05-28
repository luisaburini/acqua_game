extends Node

var locations = ["sebo", "morro", "praca"]

var morro_scenarios = ["res://img/morro1.jpg",
					   "res://img/morro2.jpg",
					   "res://img/morro3.jpg"]
var praca_scenarios = ["res://img/praca1.jpg",
					   "res://img/praca2.jpg",
					   "res://img/praca3.jpg"]
					
signal reset_pos_esquerdo
signal reset_pos_direito
# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.hide()
	$Dialogue.hide()
	$Sebo.hide()
	$MorroPelado.hide()
	$CityMap.hide()
	$HUD.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func new_game():
	$Music.play()
	$Sebo.start()
	$HUD.show_message("")	
	$Player.show()
	$Player.start($StartPosition.position)

func _on_player_limite_direito():
	print("Player limite direito")
	$Sebo.update_texture(+1)
	$Sebo.update_objs_state()
	$Dialogue.hide()
	reset_pos_direito.emit()


func _on_player_limite_esquerdo():
	print("Player limite esquerdo")
	$Sebo.update_texture(-1)
	$Sebo.update_objs_state()
	$Dialogue.hide()
	reset_pos_esquerdo.emit()

func _on_dialogue_pressed_yes():
	$Dialogue.hide()

func _on_dialogue_pressed_no():
	$Dialogue.hide()

func _on_sebo_leave():
	print("Ir para o morro")
	$Sebo.hide()
	$CityMap.show()

func _on_sebo_cannot_leave():
	$Dialogue.change_texture("res://img/capybara-ismael.png")
	$Dialogue.change_label("Ainda tem coisa pra fazer aqui")
	$Sebo.hide_dialogue()
	$Dialogue.show()
	$Dialogue.hide_interaction()
	$Dialogue.start_hide_timer()


func _on_sebo_stop_music():
	$Music.stop()


func _on_sebo_will_show_dialogue():
	$Dialogue.hide()


func _on_city_map_pressed_sebo():
	$Dialogue.hide()
	$CityMap.hide()
	$Sebo.show()


func _on_city_map_pressed_morro():
	$Dialogue.hide()
	if $Sebo.is_completed():
		$CityMap.hide()
		$MorroPelado.show()
		$Player.show()
		$Player.start($StartPosition.position)


func _on_sebo_go_to_next_scene():
	_on_player_limite_direito()


func _on_sebo_go_back_scene():
	_on_player_limite_esquerdo()
