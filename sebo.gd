extends Node2D

signal leave
signal stop_music
signal user_can_go_to(position)
signal go_to_next_scene
signal go_back_scene
signal audiodica_finished

var scenario_index = 0

var start_positions = [ 	
	Vector2(900, 450),
	Vector2(900, 500),
	Vector2(290, 450),
	Vector2(150, 500) 
]
	
func get_start_position():
	return start_positions[scenario_index]

var return_positions = [
	Vector2(900, 660),
	Vector2(900, 660),
	Vector2(900, 660),
	Vector2(900, 660)
]

func  get_return_position():
	return return_positions[scenario_index]
	
var sebo_scenarios = ["res://img/cenario/sebo/sebo1.png",
					  "res://img/cenario/sebo/sebo2.png",
					  "res://img/cenario/sebo/sebo3.png",
					  "res://img/cenario/sebo/sebo4.png"]
					
var chao_sebo = ["res://img/cenario/sebo/chao-sebo1.png",
			 	 "res://*/img/cenario/sebo/chao-sebo2.png",
				 "res://img/cenario/sebo/chao-sebo3.png",
				 "res://img/cenario/sebo/chao-sebo1.png"]
					
# Called when the node enters the scene tree for the first time.
func _ready():
	$Dialogue.hide()
	$Dialogue.hide_interaction()

func reset():
	scenario_index = 0
	$Inventory.reset()
	$Dialogue.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hide_dialogue():
	$Dialogue.hide()


var started = false

func start():
	reset()
	update_objs_state(0)
	started = true
	show()
	
func end():
	started = false
	scenario_index = 0
	hide_all()
	hide()
	
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
						# print(c.get_class())
						c.disabled = true
					for b in c.get_children():
						b.hide()
						if check_collision(b.get_class()):
							b.disabled = true
	
		
func is_completed():
	var pegou_livro = $Inventory.check_if_item_exists("livro_magico")
	var pegou_vinyl = $Inventory.check_if_item_exists("vinyl")
	var tocou_vinyl = $Inventory.check_if_item_exists("vitrola")
	return pegou_livro and pegou_vinyl and tocou_vinyl

func get_objs():
	return [
		["Ismael", "Porta1", "Obstaculo"],
		[ "Vitrola", "Porta2", "Estante2", "Estante22" ,"Retorno2", "Obstaculo2"],
		["Vinyl", "Porta3", "Estante3", "Retorno3"],
		["Saida", "Retorno4", "Obstaculo4"]
	]

func update_texture():
	# print("Sebo: update texture scenario index " + str(scenario_index))
	$Dialogue.hide() 
	$Background.texture = load(sebo_scenarios[scenario_index])
	$Chao.texture = load(chao_sebo[scenario_index])
	
func update_objs_state(limit):

	scenario_index = abs(scenario_index+limit)
	scenario_index = scenario_index%len(sebo_scenarios)
	
	update_texture()
	
	var objs = get_objs()
	for i in range(len(objs)):
		for o in objs[i]:
			var obj = get_node(o)
			if obj != null:
				if scenario_index == i:
					# print("Root obj " + o)
					obj.show()
					for c in obj.get_children():
						c.show()
						# print(c.get_class())
						if check_button(c.get_class()):
							c.hide()
						if check_collision(c.get_class()):
							# print("Enabled " + c.get_class())
							c.disabled = false
						for b in c.get_children():
							b.show()
							if check_collision(b.get_class()):
								# print("Enabled " + b.get_class())
								b.disabled = false
				else:
					# print("Root obj " + o)
					obj.hide()
					for c in obj.get_children():
						c.hide()
						if check_collision(c.get_class()):
							# print("Disabled " + c.get_class())
							c.disabled = true
						for b in c.get_children():
							b.hide()
							if check_collision(b.get_class()):
								# print("Disabled " + b.get_class())
								b.disabled = true
					
	if $Inventory.check_if_item_exists("vinyl"):
		$Vinyl.hide()
		
func check_collision(o):
	return o.begins_with("Collision")

func is_obstacle(o):
	# print("Is obstacle: " + o)
	return o.begins_with("Obstaculo") or o.begins_with("Estante")
	
func check_button(b):
	return b.ends_with("Button")

func _on_dialogue_pressed_yes():
	$LivroLongSound.play()
	$Dialogue.hide_interaction()
	$Dialogue.change_label("O Balneário Municipal exibe uma nota fiscal, emitida em 02 de abril de 1969, três meses e meio antes do homem chegar a lua pela primeira vez a bordo da Apolo 11. A pedido da NASA, foram embarcadas 100 dúzias de garrafas com 500 ml contendo água mineral de Águas de Lindóia.")
	$Dialogue.start_hide_timer()
	$Inventory.add_item("livro_magico")
	$ColetaSound.play()


func _on_dialogue_pressed_no():
	$Dialogue.hide()


func _on_audio_dica_finished():
	audiodica_finished.emit()


func _on_ismael_body_entered(body):
	if scenario_index == 0 and started and is_player(body.get_class()):
		$Dialogue.show()
		if $Inventory.check_if_item_exists("livro_magico"):
			$Dialogue.hide_interaction()
			$Dialogue.start_hide_timer()
			$Dialogue.change_texture("res://img/gcapybara.png")
			$Dialogue.change_label("Estou ocupado, vá se ocupar também.")
		else:
			$LivroShortSound.play()
			$Dialogue.change_texture("res://img/livro.png")
			$Dialogue.change_label("Gostaria de ganhar um livro mágico?")
			$Dialogue.show()

func _on_porta_1_body_entered(body):
	if scenario_index == 0 and started and is_player(body.get_class()):
		$Porta1/TextureButton.show()


func _on_porta_2_body_entered(body):
	if scenario_index == 1 and started and is_player(body.get_class()):
		$Porta2/TextureButton.show()


func _on_retorno_2_body_entered(body):
	if scenario_index == 1 and started and is_player(body.get_class()):
		$Retorno2/TextureButton.show()


func _on_vinyl_body_entered(body):
	if scenario_index == 2 and started and is_player(body.get_class()):
		$ColetaSound.play()
		$Vinyl.hide()
		$Inventory.add_item("vinyl")


func _on_retorno_4_body_entered(body):
	if scenario_index == 3 and started and is_player(body.get_class()):
		$Retorno4/TextureButton.show()


func _on_retorno_3_body_entered(body):
	if scenario_index == 2 and started and is_player(body.get_class()):
		$Retorno3/TextureButton.show()
		
func is_player(p):
	return p == "CharacterBody2D"


func _on_vitrola_body_entered(body):
	print(body.get_class() + " entered vitrola, lets see if really " + str(scenario_index))
	if scenario_index == 1 and started and is_player(body.get_class()):
		print("Entered vitrola")
		$Dialogue.show()
		$Dialogue.hide_interaction()
		$Dialogue.start_hide_timer()
		$Dialogue.change_texture("res://img/cenario/sebo/vinyl-detalhe.png")	
		var pegou_vinyl = $Inventory.check_if_item_exists("vinyl")
		var tocou_vinyl = $Inventory.check_if_item_exists("vitrola")
		if pegou_vinyl :
			if tocou_vinyl:
				$Dialogue.change_label("Já tocou o vinyl.\nNovas aventuras te aguardam!")
			else:
				$Dialogue.change_label("Tocando o vinyl!")
				stop_music.emit()
				$AudioDica.play()
				$Inventory.add_item("vitrola")
		else:
			$Dialogue.change_label("Você precisa do vinyl")


func _on_texture_button_pressed():
	$PortaSound.play()
	go_to_next_scene.emit()
	$Porta1/TextureButton.hide()


func _on_texture_button2_pressed():
	$PortaSound.play()
	go_to_next_scene.emit()
	$Porta2/TextureButton.hide()


func _on_texture_button_ret2_pressed():
	$PortaSound.play()
	go_back_scene.emit()


func _on_porta_3_body_entered(body):
	if scenario_index == 2 and started and is_player(body.get_class()):
		$Porta3/TextureButton.show()


func _on_porta_3_body_exited(body):
		if scenario_index == 2 and started:
			$Porta3/TextureButton.hide()



func _on_retorno_3_body_exited(body):
	if scenario_index == 2 and started:
		$Retorno3/TextureButton.hide()


func _on_texture_button_ret3_pressed():
	if scenario_index == 2 and started:
		$PortaSound.play()
		go_back_scene.emit()


func _on_porta_1_body_exited(body):
	if scenario_index == 0 and started:
		$Porta1/TextureButton.hide()


func _on_porta_2_body_exited(body):
	if scenario_index == 1 and started:
		$Porta2/TextureButton.hide()


func _on_retorno_2_body_exited(body):
	if scenario_index == 1 and started:
		$Retorno2/TextureButton.hide()


func _on_saida_body_entered(body):
	if scenario_index == 3 and started and is_player(body.get_class()):
		var pegou_vinyl = $Inventory.check_if_item_exists("vinyl")
		var pegou_livro = $Inventory.check_if_item_exists("livro_magico")
		var tocou_vinyl = $Inventory.check_if_item_exists("vitrola")
		if pegou_vinyl and pegou_livro and tocou_vinyl:
			leave.emit()
			$AudioDica.stop()
		else:
			$Dialogue.change_texture("res://img/capybara.png")
			$Dialogue.change_label("Ainda tem coisa pra fazer aqui")
			$Dialogue.show()
			$Dialogue.hide_interaction()
			$Dialogue.start_hide_timer()


func _on_texture_button_ret4_pressed():
	if scenario_index == 3 and started:
		$PortaSound.play()
		go_back_scene.emit()


func _on_retorno_4_body_exited(body):
	if scenario_index == 3 and started:
		$Retorno4/TextureButton.hide()


func _on_texture_button3_pressed():
	if scenario_index == 2 and started:
		$PortaSound.play()
		go_to_next_scene.emit()
