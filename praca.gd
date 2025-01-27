extends Node2D

signal go_to_next_scene
signal go_back_scene
signal leave
signal player_go_to(pos)
signal go_on_water
signal return_to_land

var ignore_click = false
var started = false

var scenario_index = 0
var rng = RandomNumberGenerator.new()
var balao_premiado = rng.randi_range(1, 3)
var baloes_estourados = []


var praca_scenarios = ["res://img/cenario/praca/praca-cena1A.png",
					   "res://img/cenario/praca/praca-cena1B.png",
					   "res://img/cenario/praca/praca-cena2A.png",
					   "res://img/cenario/praca/praca-cena2B.png",
					   "res://img/cenario/praca/praca-cena3A.png",
					   "res://img/cenario/praca/praca-cena3B.png"]
					
var chao_praca = ["res://img/cenario/praca/chao-cena1A.png",
				  "res://img/cenario/praca/chao-cena1B.png",
			 	 "res://img/cenario/praca/chao-cena2A.png",
				 "res://img/cenario/praca/chao-cena2B.png",
				 "res://img/cenario/praca/chao-cena3A.png",
				 "res://img/cenario/praca/chao-cena3B.png"]

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_tip()
	get_viewport().physics_object_picking_sort = true
	$Dialogue.hide_all()
	
func reset():
	hide_tip()
	scenario_index = 0
	rng = RandomNumberGenerator.new()
	balao_premiado = rng.randi_range(1, 3)
	baloes_estourados = []
	$Inventory.reset()
	$Dialogue.hide_all()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func start():
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
		["Obstaculo", "Arvore1", "Arvore2", "Arvore3", "Capivaras"],
		["SrBaloes", "Obstaculo2"],
		["Obstaculo3", "Obstaculo31"],
		["SrPedalinho", "Obstaculo4"],
		["Sapo", "Obstaculo5"],
		["Saida", "Obstaculo6"],
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
	$Background.texture = load(praca_scenarios[scenario_index])
	$Chao.texture = load(chao_praca[scenario_index])


func update_objs_state(limit):
	$PedalinhoSound.stop()
	
	scenario_index = abs(scenario_index+limit)
	scenario_index = scenario_index%len(praca_scenarios)
	
	update_texture()
	update_animation()
	toggle_visibility_balloons(false)
	
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
							c.hide()
						if check_collision(c.get_class()):
							c.disabled = false
						for b in c.get_children():
							b.show()
							if check_collision(b.get_class()):
								b.disabled = false
				else: 
					obj.hide()
					for c in obj.get_children():
						c.hide()
						if check_collision(c.get_class()):
							c.disabled = true
						for b in c.get_children():
							b.hide()
							if check_collision(b.get_class()):
								b.disabled = true


func update_animation():
	if scenario_index == 4 or scenario_index == 5:
		go_on_water.emit()
	else:
		return_to_land.emit()
		

func check_collision(o):
	return o.begins_with("Collision")
	
func is_obstacle(o):
	return o.begins_with("Obstaculo") or o.begins_with("Arvore")
	
func check_button(b):
	return b.ends_with("Button") 

var start_positions = [ 	
	Vector2(250, 550),
	Vector2(450, 550),
	Vector2(250, 550),
	Vector2(250, 550),
	Vector2(180, 400),
	Vector2(180, 500)
]
	
func get_start_position():
	return start_positions[scenario_index]

var return_positions = [
	Vector2(900, 550),
	Vector2(900, 550),
	Vector2(900, 550),
	Vector2(900, 550),
	Vector2(900, 300),
	Vector2(900, 300) 
]

func  get_return_position():
	return return_positions[scenario_index]	
	

func _on_porta_pressed():
	ignore_click = true
	go_to_next_scene.emit()

var is_balao_visible = false

func toggle_visibility_balloons(visible):
	var balao ="Balao"
	is_balao_visible = visible
	for i in ["1", "2", "3"]:
		var b = get_node(balao+i)
		if !visible or i in baloes_estourados:
			b.hide()
		else:
			b.show()

func _on_dialogue_pressed_yes():
	$PedalinhoSound.stop()
	if started:
		ignore_click = true
		if ofereceu_premio:
			toggle_visibility_balloons(true)
			ofereceu_premio = false

func _on_balao_1_pressed():
	ignore_click = true
	_on_balao_pressed("1")

func _on_balao_2_pressed():
	ignore_click = true
	_on_balao_pressed("2")

func _on_balao_3_pressed():
	ignore_click = true
	_on_balao_pressed("3")
	
		
func _on_balao_pressed(numero):
	var balao = get_node("Balao"+numero)
	balao.hide()
	baloes_estourados = baloes_estourados + [numero]
	if str(balao_premiado) == numero:
		$Inventory.add_item("ingresso")
		$ColetaSound.play()
		$Dialogue.change_texture("res://img/cenario/praca/ingresso.png")
		$Dialogue.change_label("Achou o balão premiado!")
	else:
		$BalaoSound.play()
		var balao_estourado = "res://img/cenario/praca/balao" + numero + "-pressed.png"
		$Dialogue.change_texture(balao_estourado)
		$Dialogue.change_label("Nada aqui dentro...")
	$Dialogue.show_all()
	$Dialogue.hide_interaction()
	toggle_visibility_balloons(false)
	

func is_completed():
	var achou_ingresso = $Inventory.check_if_item_exists("ingresso")
	var achou_garrafa = $Inventory.check_if_item_exists("garrafa")
	var andou_pedalinho = $Inventory.check_if_item_exists("pedalinho")
	return andou_pedalinho and achou_ingresso and achou_garrafa

var ofereceu_premio = false

func _on_sr_baloes_body_entered(body):
	if !is_balao_visible and started and scenario_index == 1 and is_player(body.get_class()):
		$Dialogue.show_all()
		if $Inventory.check_if_item_exists("ingresso"):
			$Dialogue.change_label("Vai lá andar no pedalinho")
			$Dialogue.change_texture("res://img/cenario/praca/sr-dos-baloes-detalhe.png")
			$Dialogue.hide_interaction()
		else:
			ofereceu_premio = true
			$Dialogue.change_label("Gostaria de estourar bexigas\npara concorrer a um prêmio?")
			$Dialogue.change_texture("res://img/cenario/praca/baloes.png")
			$Dialogue.show_all()


func is_balao_showing():
	return $Balao1.is_shape_visible() or $Balao2.is_shape_visible() or $Balao3.is_shape_visible() 


func _on_retorno_pressed():
	ignore_click = true
	go_back_scene.emit()


func _on_porta_body_entered(body):
	if started and is_player(body.get_class()):
		$Porta/TextureButton.show()


func _on_porta_body_exited(body):
	if started and is_player(body.get_class()):
		$Porta/TextureButton.hide()


func _on_saida_body_entered(body):
	if started and scenario_index == 5 and is_player(body.get_class()):
		if is_completed():
			started = false
			leave.emit()
		else:
			$Dialogue.change_texture("res://img/cenario/praca/sa")
			$Dialogue.change_label("Ainda tem coisa pra fazer aqui")
			$Dialogue.show_all()
			$Dialogue.hide_interaction()


func is_player(p):
	return p == "CharacterBody2D"

func _on_sapo_body_entered(body):
	if scenario_index == 4 and started and is_player(body.get_class()):
		$SapoSound.play()
		if $Inventory.check_if_item_exists("ingresso") and $Inventory.check_if_item_exists("pedalinho"):
			$Inventory.add_item("garrafa")
			$ColetaSound.play()
			$Dialogue.change_texture("res://img/cenario/praca/garrafa.png")
			$Dialogue.change_label("Vá até o balneário e\nencha essa garrafa.\nOs astronautas estão com sede!")	
		else:
			$Dialogue.change_texture("res://img/cenario/praca/sapo-detalhe.png")
			$Dialogue.change_label("Ainda tem coisa pra fazer aqui...")	
		$Dialogue.show_all()
		$Dialogue.hide_interaction()


func _on_sr_pedalinho_body_entered(body):
	if scenario_index == 3 and started and is_player(body.get_class()):
		if $Inventory.check_if_item_exists("pedalinho"):
			$PedalinhoSound.play()
			$Dialogue.change_label("Bom passeio, siga a diante!")
		else:
			if $Inventory.check_if_item_exists("ingresso"):
				$PedalinhoSound.play()
				$Dialogue.change_label("Você tem o ingresso!\nVá andar no pedalinho.")
				$Inventory.add_item("pedalinho")
				$ColetaSound.play()
			else:
				$Dialogue.change_label("Para andar no pedalinho é necessário ter o ingresso.")
		$Dialogue.change_texture("res://img/cenario/praca/pedalinho.png")
		$Dialogue.show_all()
		$Dialogue.hide_interaction()


func _on_retorno_body_entered(body):
	if started and is_player(body.get_class()):
		$Retorno/TextureButton.show()


func _on_retorno_body_exited(body):
	if started and is_player(body.get_class()):
		$Retorno/TextureButton.hide()


func _on_capivaras_body_entered(body):
	if scenario_index == 0 and started and is_player(body.get_class()):
		$Dialogue.change_texture("res://img/cenario/praca/capybara.png")
		$Dialogue.change_label("Siga em frente para obter um presente.\nQuem sabe até onde você pode chegar?")	
		$Dialogue.show_all()
		$Dialogue.hide_interaction()


func _on_dialogue_pressed_no():
	$PedalinhoSound.stop()
	if started:
		ignore_click = true
		if ofereceu_premio:
			ofereceu_premio = false

func _unhandled_input(event):
	if started:
		get_viewport().set_input_as_handled()


func _on_dialogue_player_go_to(pos):
	if started:
		if ignore_click:
			ignore_click = false
		else:
			player_go_to.emit(pos)

func show_tip():
	var achou_ingresso = $Inventory.check_if_item_exists("ingresso")
	var andou_pedalinho = $Inventory.check_if_item_exists("pedalinho")
	var achou_garrafa = $Inventory.check_if_item_exists("garrafa")
	match scenario_index:
		0:
			_dica_capivara()
		1:
			_dica_sr_dos_baloes(achou_ingresso)
		2:
			_dica_ex_patos(achou_ingresso)
		3:
			_dica_sr_do_pedalinho(achou_ingresso, andou_pedalinho)
		4:
			_dica_sapo(achou_ingresso, andou_pedalinho, achou_garrafa)
		5:
			_dica_saida()
		_:
			print("Where are you?")	
	$Timer.start(2)

func _dica_capivara() -> void:
	$DicaPorta.show()
	

func _dica_sr_dos_baloes(achou_ingresso) -> void:
	if !achou_ingresso:
		$DicaSrBaloes.show()
		return
	$DicaPorta.show()
	
func _dica_ex_patos(achou_ingresso) -> void:
	if !achou_ingresso:
		$DicaRetorno.show()
		return
	$DicaPorta.show()
	
func _dica_sr_do_pedalinho(achou_ingresso, andou_pedalinho) -> void:
	if !achou_ingresso:
		$DicaRetorno.show()
		return
	if!andou_pedalinho:
		$DicaSrPedalinho.show()
		return
	$DicaPorta.show()
	
func _dica_sapo(achou_ingresso, andou_pedalinho, achou_garrafa) -> void:
	if !achou_ingresso or !andou_pedalinho:
		$DicaRetorno.show()
		return
	if !achou_garrafa:
		$DicaSapo.show()
		return
	$DicaPorta.show()

func _dica_saida() -> void:
	if is_completed():
		$DicaPorta.show()
		return
	$DicaRetorno.show()

func _on_timer_timeout() -> void:
	hide_tip()
	
func hide_tip():
	$DicaPorta.hide()
	$DicaRetorno.hide()
	$DicaSrBaloes.hide()
	$DicaSrPedalinho.hide()
	$DicaSapo.hide()
