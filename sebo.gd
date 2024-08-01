extends CanvasLayer

signal leave
signal cannot_leave
signal stop_music
signal will_show_dialogue
signal user_can_go_to(position)
signal hide_user
signal show_user
signal go_to_next_scene
signal go_back_scene

var scenario_index = 0

var start_positions = [ 	
	Vector2(900, 450),
	Vector2(250, 500),
	Vector2(350, 600),
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hide_dialogue():
	$Dialogue.hide()

	
func start():
	show()
	scenario_index = 0
	update_objs_state()
	
		
func is_completed():
	return played_vinyl and $Inventory.check_if_item_exists("livro_magico")


func update_texture(limit):
	scenario_index = abs(scenario_index+limit)
	scenario_index = scenario_index%len(sebo_scenarios)
	$Background.texture = load(sebo_scenarios[scenario_index])
	$Chao.texture = load(chao_sebo[scenario_index])
	
func update_objs_state():
	$Dialogue.hide()
	var objs = [
		["Ismael", "Porta1", "Obstaculo"],
		[ "Vitrola", "Porta2", "Estante2", "Retorno2"],
		["Vinyl", "Porta3", "Estante3", "Retorno3"],
		["Saida", "Retorno4"]
	]
	for i in range(len(objs)):
		for o in objs[i]:
			var obj = get_node(o)
			if scenario_index == i:
				obj.show()
				if obj.get_class() == "TextureButton":
					obj.disabled = false
				if obj.get_class() == "StaticBody2D":
					for c in obj.get_children():
						c.disabled = false
			else:
				obj.hide()
				if obj.get_class() == "TextureButton":
					obj.disabled = true
				if obj.get_class() == "StaticBody2D":
					for c in obj.get_children():
						c.disabled = true
					
	if $Inventory.check_if_item_exists("vinyl"):
		$Vinyl.hide()
		
func _on_vitrola_pressed():
	will_show_dialogue.emit()
	$Dialogue.show()
	$Dialogue.hide_interaction()
	$Dialogue.start_hide_timer()
	$Dialogue.change_texture("res://img/vinyl-detalhe.png")	
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
		if scenario_index == 0 and $Porta1.check_if_click_is_inside(event.position):
			go_to_next_scene.emit()
			return
		user_can_go_to.emit(event.position)

func _on_porta_2_pressed():
	go_to_next_scene.emit()

func _on_retorno_3_pressed():
	go_back_scene.emit()

func _on_retorno_2_pressed():
	go_back_scene.emit()

func _on_ismael_pressed():
	if scenario_index == 0:
		will_show_dialogue.emit()
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
			cannot_leave.emit()
	else:
		go_to_next_scene.emit()


func _on_retorno_4_pressed():
	go_back_scene.emit()
