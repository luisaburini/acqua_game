extends CanvasLayer

signal leave
signal stop_music
signal user_can_go_to(position)
signal go_to_next_scene
signal go_back_scene
signal audiodica_finished

var scenario_index = 0

var start_positions = [ 	
	Vector2(900, 450),
	Vector2(900, 260),
	Vector2(290, 450),
	Vector2(380, 470) 
]
	
func get_start_position():
	return start_positions[scenario_index]

var return_positions = [
	Vector2(380, 500),
	Vector2(380, 560),
	Vector2(400, 500),
	Vector2(250, 500)
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
				
var played_vinyl = false
					
# Called when the node enters the scene tree for the first time.
func _ready():
	$Dialogue.hide()
	$Dialogue.hide_interaction()

func reset():
	scenario_index = 0
	played_vinyl = false
	$Inventory.reset()
	$Dialogue.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hide_dialogue():
	$Dialogue.hide()

	
func start():
	show()
	update_objs_state(0)
	
		
func is_completed():
	return played_vinyl and $Inventory.check_if_item_exists("livro_magico")


func update_texture():
	$Dialogue.hide()
	$Background.texture = load(sebo_scenarios[scenario_index])
	$Chao.texture = load(chao_sebo[scenario_index])
	
func update_objs_state(limit):
	scenario_index = abs(scenario_index+limit)
	scenario_index = scenario_index%len(sebo_scenarios)
	
	update_texture()
	
	var objs = [
		["Ismael", "Porta1", "Obstaculo"],
		[ "Vitrola", "Porta2", "Estante2", "Retorno2"],
		["Vinyl", "Porta3", "Estante3", "Retorno3"],
		["Saida", "Retorno4"]
	]
	for i in range(len(objs)):
		for o in objs[i]:
			var obj = get_node(o)
			if obj != null:
				if scenario_index == i:
					obj.show()
					if check_collision(obj):
						obj.disabled = false
					print("Sebo: " + obj.get_class()+" update_objs_state")
					for c in obj.get_children():
						print("Sebo: " + c.get_class()+" update_objs_state")
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
					
	if $Inventory.check_if_item_exists("vinyl"):
		$Vinyl.hide()
		
func check_collision(o):
	return o.get_class() == "CollisionShape2D" or o.get_class() == "CollisionPolygon2D"


func _on_vitrola_pressed():
	$Dialogue.show()
	$Dialogue.hide_interaction()
	$Dialogue.start_hide_timer()
	$Dialogue.change_texture("res://img/cenario/sebo/vinyl-detalhe.png")	
	if $Inventory.check_if_item_exists("vinyl") and !played_vinyl:
		$Dialogue.change_label("Tocando o vinyl!")
		stop_music.emit()
		$AudioDica.play()
		played_vinyl = true
	if !$Inventory.check_if_item_exists("vinyl"):
		$Dialogue.change_label("Você precisa do vinyl")



func _on_dialogue_pressed_yes():
	$Dialogue.hide()
	$Inventory.add_item("livro_magico")


func _on_dialogue_pressed_no():
	$Dialogue.hide()

func _unhandled_input(event):
	if event is InputEventScreenTouch and event.pressed == true:
		user_can_go_to.emit(event.position)

func _on_porta_2_pressed():
	go_to_next_scene.emit()

func _on_retorno_3_pressed():
	go_back_scene.emit()

func _on_retorno_2_pressed():
	go_back_scene.emit()

func _on_ismael_pressed():
	if scenario_index == 0:
		$Dialogue.show()
		if $Inventory.check_if_item_exists("livro_magico"):
			$Dialogue.hide_interaction()
			$Dialogue.start_hide_timer()
			$Dialogue.change_texture("res://img/capybara-ismael.png")
			$Dialogue.change_label("Estou ocupado, vá se ocupar também.")
		else:
			$Dialogue.change_texture("res://img/livro.png")
			$Dialogue.change_label("Gostaria de ganhar um livro mágico?")
			$Dialogue.show_interaction()


func _on_vinyl_pressed():
	$Vinyl.hide()
	$Inventory.add_item("vinyl")


func _on_porta_3_pressed():
	go_to_next_scene.emit()


func _on_saida_pressed():
	if scenario_index == 3:
		if $Inventory.check_if_item_exists("vinyl") and $Inventory.check_if_item_exists("livro_magico") and played_vinyl:
			leave.emit()
			$AudioDica.stop()
		else:
			$Dialogue.change_texture("res://img/capybara-ismael.png")
			$Dialogue.change_label("Ainda tem coisa pra fazer aqui")
			$Dialogue.show()
			$Dialogue.hide_interaction()
			$Dialogue.start_hide_timer()
	else:
		go_to_next_scene.emit()


func _on_retorno_4_pressed():
	go_back_scene.emit()


func _on_audio_dica_finished():
	audiodica_finished.emit()


func _on_porta_1_pressed():
	go_to_next_scene.emit()
