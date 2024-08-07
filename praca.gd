extends Node2D

signal go_to_next_scene
signal go_back_scene
signal user_can_go_to(position)
signal leave

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
	$Dialogue.hide()
	update_objs_state(0)
	
func reset():
	scenario_index = 0
	rng = RandomNumberGenerator.new()
	balao_premiado = rng.randi_range(1, 3)
	baloes_estourados = []
	$Inventory.reset()
	$Dialogue.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func start():
	show()
	update_objs_state(0)
	
func get_objs():
		return [
		[],
		["SrBaloes"],
		[],
		["SrPedalinho"],
		["Sapo"],
		["Saida"],
	]
	
func hide_all():
	var objs = get_objs()
	var si = scenario_index
	update_objs_state(1000)
	scenario_index = si
	
func update_texture():
	$Dialogue.hide()
	$Background.texture = load(praca_scenarios[scenario_index])
	$Chao.texture = load(chao_praca[scenario_index])


func update_objs_state(limit):
	scenario_index = abs(scenario_index+limit)
	scenario_index = scenario_index%len(praca_scenarios)
	
	update_texture()
	toggle_visibility_balloons(false)
	
	var objs = get_objs()
	for i in range(len(objs)):
		for o in objs[i]:
			var obj = get_node(o)
			if obj != null:
				if scenario_index == i:
					obj.show()
					if check_collision(obj):
						obj.disabled = false
					print("Praca: " + obj.get_class()+" update_objs_state")
					for c in obj.get_children():
						print("Praca: " + c.get_class()+" update_objs_state")
						if check_collision(c):
							c.disabled = false
						for b in c.get_children():
							if check_collision(b):
								b.disabled = false
				else:
					obj.hide()
					if check_collision(obj):
						obj.disabled = true
					for c in obj.get_children():
						if check_collision(c):
							c.disabled = true
						for b in c.get_children():
							if check_collision(b):
								b.disabled = true
					
func check_collision(o):
	return o.get_class() == "CollisionShape2D" or o.get_class() == "CollisionPolygon2D"


var start_positions = [ 	
	Vector2(350, 500),
	Vector2(350, 500),
	Vector2(350, 500),
	Vector2(350, 500),
	Vector2(350, 500),
	Vector2(350, 500) 
]
	
func get_start_position():
	return start_positions[scenario_index]

var return_positions = [
	Vector2(900, 500),
	Vector2(900, 500),
	Vector2(900, 500),
	Vector2(900, 500),
	Vector2(900, 500),
	Vector2(900, 500) 
]

func  get_return_position():
	return return_positions[scenario_index]			


func _on_sr_baloes_pressed():
	if $Inventory.check_if_item_exists("bilhete"):
		$Dialogue.change_label("Vai lá andar no pedalinho")
		$Dialogue.change_texture("res://img/cenario/praca/pedalinho.png")
		$Dialogue.start_hide_timer()
		$Dialogue.show()
		$Dialogue.hide_interaction()
	else:
		$Dialogue.change_label("Gostaria de estourar bexigas\npara concorrer a um prêmio?")
		$Dialogue.change_texture("res://img/cenario/praca/baloes.png")
		$Dialogue.show()
	

func _on_porta_pressed():
	go_to_next_scene.emit()


func _on_retorno_pressed():
	go_back_scene.emit()


func _on_sr_pedalinho_pressed():
	if $Inventory.check_if_item_exists("bilhete"):
		$Dialogue.change_label("Você tem o bilhete!\nVenha andar no pedalinho.")
		$Inventory.add_item("pedalinho")
	else:
		$Dialogue.change_label("Para andar no pedalinho é necessário ter o bilhete.")
	$Dialogue.change_texture("res://img/cenario/praca/pedalinho.png")
	$Dialogue.show()
	$Dialogue.hide_interaction()
	$Dialogue.start_hide_timer()

func toggle_visibility_balloons(visible):
	var balao ="Balao"
	for i in ["1", "2", "3"]:
		var b = get_node(balao+i)
		if !visible or i in baloes_estourados:
			b.hide()
		else:
			b.show()
			

func _on_dialogue_pressed_yes():
	$Dialogue.hide()
	toggle_visibility_balloons(true)

func _on_balao_1_pressed():
	_on_balao_pressed("1")

func _on_balao_2_pressed():
	_on_balao_pressed("2")

func _on_balao_3_pressed():
	_on_balao_pressed("3")
	
		
func _on_balao_pressed(numero):
	var balao = get_node("Balao"+numero)
	balao.hide()
	baloes_estourados = baloes_estourados + [numero]
	if str(balao_premiado) == numero:
		$Inventory.add_item("bilhete")
		$Dialogue.change_texture("res://img/cenario/praca/bilhete.png")
		$Dialogue.change_label("Achou o bilhete premiado!")
	else:
		var balao_estourado = "res://img/cenario/praca/balao" + numero + "-detalhe.png"
		$Dialogue.change_texture(balao_estourado)
		$Dialogue.change_label("Nada aqui dentro...")
		
	
	$Dialogue.start_hide_timer()
	$Dialogue.show()
	$Dialogue.hide_interaction()
	toggle_visibility_balloons(false)
	

func is_completed():
	var achou_bilhete = $Inventory.check_if_item_exists("bilhete")
	var achou_garrafa = $Inventory.check_if_item_exists("garrafa")
	var andou_pedalinho = $Inventory.check_if_item_exists("pedalinho")
	return andou_pedalinho and achou_bilhete and achou_garrafa

func _on_saida_pressed():
	if is_completed():
		print("Praca: Pode sair")
		leave.emit()
	else:
		$Dialogue.change_label("Ainda tem coisa pra fazer aqui")
		$Dialogue.show()
		$Dialogue.hide_interaction()
		$Dialogue.start_hide_timer()

func _on_sapo_pressed():
	if $Inventory.check_if_item_exists("bilhete") and $Inventory.check_if_item_exists("pedalinho"):
		$Inventory.add_item("garrafa")
		$Dialogue.change_texture("res://img/cenario/praca/garrafa.png")
		$Dialogue.change_label("Leve essa garrafa adiante!")	
	else:
		$Dialogue.change_texture("res://img/cenario/praca/sapo-detalhe.png")
		$Dialogue.change_label("Ainda tem coisa pra fazer aqui...")	
	
	$Dialogue.start_hide_timer()
	$Dialogue.show()
	$Dialogue.hide_interaction()
