extends Node2D

signal go_to_next_scene
signal go_back_scene
signal user_can_go_to(position)
signal leave

var scenario_index = 0

var balneario_scenarios = ["res://img/cenario/balneario/balneario-cena1A.png",
					   	   "res://img/cenario/balneario/balneario-cena1B.png",
						   "res://img/cenario/balneario/balneario-cena2A.png",
						   "res://img/cenario/balneario/balneario-cena2B.png",
						   "res://img/cenario/balneario/balneario-cena3A.png",
						   "res://img/cenario/balneario/balneario-cena3B.png"]
					
var chao_balneario = ["res://img/cenario/balneario/chao-cena1A.png",
					  "res://img/cenario/balneario/chao-cena1B.png",
			 		  "res://img/cenario/balneario/chao-cena2A.png",
					  "res://img/cenario/balneario/chao-cena2B.png",
					  "res://img/cenario/balneario/chao-cena3A.png",
					  "res://img/cenario/balneario/chao-cena3B.png"]


# Called when the node enters the scene tree for the first time.
func _ready():
	$Lua.hide()
	$Dialogue.hide()
	update_objs_state(0)

func reset():
	scenario_index = 0
	$Inventory.reset()
	$Lua.hide()
	$Dialogue.hide()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start():
	show()
	$Lua.hide()
	update_objs_state(0)

func get_objs():
		return [
		["Guardasol"],
		["Senhora"],
		[""],
		[""],
		["Placa"],
		["Fonte"],
	]
	

func hide_all():
	var objs = get_objs()
	for i in range(len(objs)):
		for o in objs[i]:
			var obj = get_node(o)
			if obj != null:
				# print("Root Node: "+ o)
				if check_collision(o):
					obj.disabled = true
				for c in obj.get_children():
					if check_collision(c.get_class()):
						# print(c.get_class())
						c.disabled = true
					for b in c.get_children():
						if check_collision(b.get_class()):
							b.disabled = true
	
func update_texture():
	$Dialogue.hide()
	$Background.texture = load(balneario_scenarios[scenario_index])
	$Chao.texture = load(chao_balneario[scenario_index])


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
					if check_collision(o):
						obj.disabled = false
					for c in obj.get_children():
						if check_collision(c.get_class()):
							c.disabled = false
						for b in c.get_children():
							if check_collision(b.get_class()):
								b.disabled = false
				else:
					obj.hide()
					if check_collision(o):
						obj.disabled = true
					for c in obj.get_children():
						if check_collision(c.get_class()):
							c.disabled = true
						for b in c.get_children():
							if check_collision(b.get_class()):
								b.disabled = true

func check_collision(o):
	return o == "CollisionShape2D" or o == "CollisionPolygon2D"

func _on_retorno_pressed():
	go_back_scene.emit()


func _on_porta_pressed():
	go_to_next_scene.emit()


func _on_senhora_pressed():
	$Dialogue.change_texture("res://img/cenario/balneario/gota.png")	
	$Dialogue.change_label("Você já tem a garrafa,\nagora só falta a água.\nOnde poderia estar?")
	$Dialogue.show()
	$Dialogue.hide_interaction()
	$Dialogue.start_hide_timer()
	$Inventory.add_item("senhora")
	$ColetaSound.play()
	
var start_positions = [ 	
	Vector2(600, 500),
	Vector2(600, 500),
	Vector2(600, 500),
	Vector2(400, 500),
	Vector2(600, 500),
	Vector2(600, 500) 
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


func _on_fonte_pressed():
	if is_completed():
		$AguaSound.play()
		$Lua.show()
		$Dialogue.change_texture("res://img/cenario/balneario/gota.png")	
		$Dialogue.change_label("Enchendo a garrafa...")
	else:
		$Dialogue.change_texture("res://img/cenario/balneario/gota.png")	
		$Dialogue.change_label("Ainda tem coisa para fazer...")
	$Dialogue.show()
	$Dialogue.hide_interaction()
	$Dialogue.start_hide_timer()

func _on_lua_pressed():
	$AguaSound.stop()
	leave.emit()
	
func is_completed():
	var interagiu_com_senhora = $Inventory.check_if_item_exists("senhora")
	var leu_placa = $Inventory.check_if_item_exists("placa")
	return interagiu_com_senhora and leu_placa


func _on_placa_pressed():
	$Dialogue.change_texture("res://img/cenario/balneario/gota.png")	
	$Dialogue.change_label("Temos muito orgulho de ter matado a sede\ndos astronautas da missão Apollo 11.")
	$Dialogue.show()
	$Dialogue.hide_interaction()
	$Dialogue.start_hide_timer()
	$Inventory.add_item("placa")
	$ColetaSound.play()
