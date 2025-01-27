extends Node2D

signal go_to_next_scene
signal go_back_scene
signal player_go_to(pos)
signal leave
var ignore_click = false
var scenario_index = 0

var balneario_scenarios = ["res://img/cenario/balneario/balneario-cena1A.png",
					   	   "res://img/cenario/balneario/balneario-cena1B.png",
						   "res://img/cenario/balneario/balneario-cena2A.png",
						   "res://img/cenario/balneario/balneario-cena2B.png",
						   "res://img/cenario/balneario/balneario-cena3A.png",
						   "res://img/cenario/balneario/balneario-cena3B.png"]
					
var chao_balneario = ["res://img/cenario/balneario/balneario-cena1A.png",
					  "res://img/cenario/balneario/balneario-cena1B.png",
			 		  "res://img/cenario/balneario/balneario-cena2A.png",
					  "res://img/cenario/balneario/balneario-cena2B.png",
					  "res://img/cenario/balneario/balneario-cena3A.png",
					  "res://img/cenario/balneario/balneario-cena3B.png"]


# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().physics_object_picking_sort = true
	$Lua.hide()
	$Dialogue.hide_all()
	hide_tip()

func reset():
	scenario_index = 0
	hide_tip()
	$Inventory.reset()
	$Lua.hide()
	$Dialogue.hide_all()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
var started = false

func start():
	$Lua.hide()
	$Porta/TextureButton.hide()
	$Retorno/TextureButton.hide()
	scenario_index = 0
	show()
	update_objs_state(0)
	started = true

func end():
	started = false
	scenario_index = 0
	hide_all()

func get_objs():
		return [
		["Obstaculo", "Piscina"],
		["Senhora", "Obstaculo2", "Obstaculo21"],
		["Obstaculo3", "Obstaculo33"],
		["Obstaculo4", "Obstaculo41"],
		["Placa", "Obstaculo5"],
		["Fonte", "Obstaculo6"],
	]
	

func hide_all():
	var objs = get_objs()
	for i in range(len(objs)):
		for o in objs[i]:
			var obj = get_node(o)
			if obj != null:
				obj.hide()
				if check_collision(o):
					obj.disabled = true
				for c in obj.get_children():
					c.hide()
					if check_collision(c.get_class()):
						c.disabled = true
					for b in c.get_children():
						b.hide()
						if check_collision(b.get_class()):
							b.disabled = true
	hide()
	

func update_texture():
	$Dialogue.hide_all()
	hide_tip()
	if scenario_index == 0:
		$Retorno.hide()
	else:
		$Retorno.show()
	$Background.texture = load(balneario_scenarios[scenario_index])
	$Chao.texture = load(chao_balneario[scenario_index])


func is_player(p):
	return p == "CharacterBody2D"

func update_objs_state(limit):
	scenario_index = abs(scenario_index+limit)
	scenario_index = scenario_index%len(balneario_scenarios)

	update_texture()
	
	var objs = get_objs()
	for i in range(len(objs)):
		for o in objs[i]:
			var obj = get_node(o)
			if obj != null:
				if scenario_index == i:
					obj.show()
					for c in obj.get_children():
						c.show()
						if check_button(c.get_class()):
							print(o)
							c.hide()
						if check_collision(c.get_class()):
							c.disabled = false
						for b in c.get_children():
							b.show()
							if check_collision(b.get_class()):
								b.disabled = false
				else:
					print(o)
					obj.hide()
					for c in obj.get_children():
						c.hide()
						if check_collision(c.get_class()):
							c.disabled = true
						for b in c.get_children():
							b.hide()
							if check_collision(b.get_class()):
								b.disabled = true


func check_collision(o):
	return o.begins_with("Collision")

func check_button(b):
	return b.ends_with("Button")

func _on_porta_pressed():
	ignore_click = true
	if started:
		go_to_next_scene.emit()


var start_positions = [ 	
	Vector2(600, 500),
	Vector2(100, 500),
	Vector2(300, 400),
	Vector2(300, 400),
	Vector2(600, 500),
	Vector2(100, 500) 
]
	
func get_start_position():
	return start_positions[scenario_index]

var return_positions = [
	Vector2(900, 500),
	Vector2(900, 500),
	Vector2(900, 380),
	Vector2(1000, 380),
	Vector2(900, 500),
	Vector2(900, 500) 
]

func  get_return_position():
	return return_positions[scenario_index]			


func _on_lua_pressed():
	$Dialogue.hide_all()
	$AguaSound.stop()
	leave.emit()
	
func is_completed():
	var interagiu_com_senhora = $Inventory.check_if_item_exists("senhora")
	var leu_placa = $Inventory.check_if_item_exists("placa")
	return interagiu_com_senhora and leu_placa


func _on_senhora_body_entered(body):
	if is_player(body.get_class()) and scenario_index == 1 and started:
		$Dialogue.change_texture("res://img/cenario/praca/garrafa.png")	
		$Dialogue.change_label("Você já tem a garrafa,\nagora só falta a água.\nOnde poderia estar?")
		$Dialogue.show_all()
		$Dialogue.hide_interaction()
		$Inventory.add_item("senhora")
		$ColetaSound.play()


func _on_retorno_pressed():
	if started:
		go_back_scene.emit()


func _on_retorno_body_entered(body):
	if started and is_player(body.get_class()):
		$Retorno/TextureButton.show()


func _on_retorno_body_exited(body):
	if started and is_player(body.get_class()):
		$Retorno/TextureButton.hide()


func _on_porta_body_entered(body):
	if started and is_player(body.get_class()):
		print("Show porta")
		$Porta/TextureButton.show()


func _on_porta_body_exited(body):
	if started and is_player(body.get_class()):
		print("Hide porta")
		$Porta/TextureButton.hide()


func _on_placa_body_entered(body):
	if is_player(body.get_class()) and scenario_index == 4 and started:
		$Dialogue.change_texture("res://img/cenario/balneario/astronauta.png")	
		$Dialogue.change_label("Temos muito orgulho de ter matado a sede\ndos astronautas da missão Apollo 11.")
		$Dialogue.show_all()
		$Dialogue.hide_interaction()
		$Inventory.add_item("placa")
		$ColetaSound.play()


func _on_fonte_body_entered(body):
	if is_player(body.get_class()) and started and scenario_index == 5:
		if is_completed():
			$AguaSound.play()
			$Lua.show()
			$Dialogue.change_texture("res://img/cenario/balneario/gota.png")	
			$Dialogue.change_label("Enchendo a garrafa...")
		else:
			$Dialogue.change_texture("res://img/cenario/balneario/gota.png")	
			$Dialogue.change_label("Ainda tem coisa para fazer...")
		$Dialogue.show_all()
		$Dialogue.hide_interaction()


func _on_dialogue_player_go_to(pos):
	if started:
		if ignore_click:
			ignore_click = false
		else:
			player_go_to.emit(pos)


func _on_dialogue_pressed_no():
	if started:
		ignore_click = true


func _on_dialogue_pressed_yes():
	if started:
		ignore_click = true
	
func _unhandled_input(event):
	if started:
		get_viewport().set_input_as_handled()

func show_tip():
	print("Balneário show tip")
	var interagiu_com_senhora = $Inventory.check_if_item_exists("senhora")
	var leu_placa = $Inventory.check_if_item_exists("placa")
	match scenario_index:
		0:
			_dica_piscina()
		1:
			_dica_senhora(interagiu_com_senhora)
		2:
			_dica_passagem(interagiu_com_senhora)
		3:
			_dica_passagem(interagiu_com_senhora)
		4:
			_dica_placa(interagiu_com_senhora, leu_placa)
		5:
			_dica_saida()
		_:
			print("Where are you?")
	$Timer.start(2)

func hide_tip():
	$DicaPorta.hide()
	$DicaRetorno.hide()
	$DicaSenhora.hide()
	$DicaPlaca.hide()
	$DicaFonte.hide()
	
func _dica_piscina():
	$DicaPorta.show()
	
func _dica_senhora(interagiu_com_senhora):
	if interagiu_com_senhora:
		$DicaPorta.show()
		return
	$DicaSenhora.show()
	
func _dica_passagem(interagiu_com_senhora):
	if interagiu_com_senhora:
		$DicaPorta.show()
		return
	$DicaRetorno.show()
	
func _dica_placa(interagiu_senhora, leu_placa):
	if !interagiu_senhora:
		$DicaRetorno.show()
		return
	if !leu_placa:
		$DicaPlaca.show()
		return
	$DicaPorta.show()
	
func _dica_saida():
	if !is_completed():
		$DicaRetorno.show()
		return
	$DicaFonte.show()


func _on_timer_timeout() -> void:
	hide_tip()
