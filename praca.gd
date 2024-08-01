extends Node2D

signal go_to_next_scene
signal go_back_scene
signal user_can_go_to(position)

var scenario_index = 0

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
	$Dialogue.hide_interaction()
	update_objs_state()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start():
	show()
	scenario_index = 0
	update_objs_state()
	
func get_objs():
		return [
		[""],
		["SrBaloes", ""],
		[""],
		["SrPedalinho", ""],
		[""],
		[""],
	]
	
func hide_all():
	var objs = get_objs()
	var si = scenario_index
	scenario_index = 1000
	update_objs_state()
	scenario_index = si
	
func update_texture(limit):
	$Dialogue.hide()
	scenario_index = abs(scenario_index+limit)
	scenario_index = scenario_index%len(praca_scenarios)
	$Background.texture = load(praca_scenarios[scenario_index])
	$Chao.texture = load(chao_praca[scenario_index])


func update_objs_state():
	print("START: update objs state")
	print(scenario_index)
	var objs = get_objs()
	for i in range(len(objs)):
		for o in objs[i]:
			var obj = get_node(o)
			if scenario_index == i:
				if obj != null:
					print(obj.get_class())
					obj.show()
					if obj.get_class() == "StaticBody2D":
						for c in obj.get_children():
							c.disabled = false
			else:
				if obj != null:
					print(obj.get_class())
					obj.hide()
					if obj.get_class() == "StaticBody2D":
						for c in obj.get_children():
							c.disabled = true
	print("END: update objs state")
					
var start_positions = [ 	
	Vector2(250, 500),
	Vector2(250, 500),
	Vector2(250, 500),
	Vector2(250, 500),
	Vector2(250, 500),
	Vector2(250, 500) 
]
	
func get_start_position():
	return start_positions[scenario_index]

var return_positions = [
	Vector2(1000, 500),
	Vector2(1000, 500),
	Vector2(1000, 500),
	Vector2(1000, 500),
	Vector2(1000, 500),
	Vector2(1000, 500) 
]

func  get_return_position():
	return return_positions[scenario_index]			


func _on_sr_baloes_pressed():
	print("pressed Sr Baloes")
	$Dialogue.change_label("Salve")
	$Dialogue.change_texture("res://img/cenario/praca/baloes.png")
	$Dialogue.start_hide_timer()
	$Dialogue.show()
	$Dialogue.hide_interaction()

func _on_porta_pressed():
	print("Pressed porta")
	go_to_next_scene.emit()


func _on_retorno_pressed():
	print("Pressed retorno")
	scenario_index
	go_back_scene.emit()
	


func _on_sr_pedalinho_pressed():
	print("pressed Sr Pedalinho")
	$Dialogue.change_label("Pedalinho")
	$Dialogue.change_texture("res://img/cenario/praca/pedalinho.png")
	$Dialogue.show()
