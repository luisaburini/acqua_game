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
signal stop_at_obstacle


var scenario_index = 0
var sebo_scenarios = ["res://img/cenario/sebo/sebo1.png",
					  "res://img/cenario/sebo/sebo2.png",
					  "res://img/cenario/sebo/sebo3.png",
					  "res://img/cenario/sebo/sebo4.png"]
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

func hide_objs():
	$Dialogue.hide()
	$Dialogue.hide_interaction()
	$Door.hide()
	$Ismael.hide()
	$Vinyl.hide()
	$Gramophone.hide()
	hide()
	
func start():
	scenario_index = 0
	update_objs_state()
	show()
	$TextureRect.show()
	$Ismael.show()
		
func is_completed():
	return played_vinyl and $Inventory.check_if_item_exists("livro_magico")

func update_texture(limit):
	scenario_index = scenario_index+limit
	scenario_index = scenario_index%len(sebo_scenarios)
	$TextureRect.texture = load(sebo_scenarios[scenario_index])
	
func update_objs_state():
	$Dialogue.hide()
	var objs = ["Ismael", "Vinyl", "Gramophone"]
	for i in range(len(objs)):		
		var obj = get_node(objs[i])
		if scenario_index == i:
			obj.show()
		else:
			obj.hide()
	if scenario_index == 2:
		$Door.show()
	else:
		$Door.hide()
	if $Inventory.check_if_item_exists("vinyl"):
		$Vinyl.hide()
		
func _on_gramophone_pressed():
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


func _on_door_pressed():
	if $Inventory.check_if_item_exists("vinyl") and $Inventory.check_if_item_exists("livro_magico") and played_vinyl:
		leave.emit()
		$AudioDica.stop()
	else:
		cannot_leave.emit()


func _on_dialogue_pressed_yes():
	$Dialogue.hide()
	$Inventory.add_item("livro_magico")


func _on_dialogue_pressed_no():
	$Dialogue.hide()


func _on_vinyl_pressed():
	$Vinyl.hide()
	$Inventory.add_item("vinyl")


func _on_ismael_pressed():
	will_show_dialogue.emit()
	$Dialogue.show()
	if $Inventory.check_if_item_exists("livro_magico"):
		$Dialogue.hide_interaction()
		$Dialogue.start_hide_timer()
		$Dialogue.change_texture("res://img/capybara-ismael.png")
		$Dialogue.change_label("Estou ocupado")
	else:
		$Dialogue.change_texture("res://img/livro.png")
		$Dialogue.change_label("Gostaria de ganhar um livro mágico?")
		$Dialogue.show_interaction()

var first_click = true
func _on_player_user_clicked(position):
	if first_click:
		first_click = false
		return
	# Verificar se click do usuario esta em posicao ilegal
	if not illegal(position):
		user_can_go_to.emit(position)
			
func illegal(position):
	show_user.emit()
	match scenario_index:
		0:
			if position.x > 0 and position.x < 1280:
				if position.y > 500 and position.y < 720:
					return false
			if position.x > 350 and position.x < 450:
				if position.y > 410 and position.y < 500:
					go_to_next_scene.emit()
					return false
			return true
		1:
			if position.x > 625 and position.x < 980:
				if position.y > 430 and position.y < 700:
					return false
			if position.x > 200 and position.x < 1040:
				if position.x > 1020:
					go_to_next_scene.emit()
				if position.y > 620 and position.y < 720:
					return false
			if position.x > 230 and position.x < 360:
				if position.x < 250:
					go_back_scene.emit()
				if position.y > 430 and position.y < 670:
					return false
			return true
		2: 
			if position.x > 860 and position.x < 1040:
				if position.x > 1020:
					go_to_next_scene.emit()
				if position.y > 420 and position.y < 680:
					return false
			if position.x > 170 and position.x < 260:
				if position.x < 200:
					go_back_scene.emit()
				if position.y > 410 and position.y < 640:
					return false
			if position.x > 220 and position.x < 270:
				if position.y > 30 and position.y < 420:
					return false
			if position.x > 270 and position.x < 870:
				if position.y > 520 and position.y < 603:
					hide_user.emit()
				return false
			return true
		3:
			if position.x > 0 and position.x < 1280:
				if position.y > 500 and position.y < 720:
					return false
			if position.x > 350 and position.x < 450:
				if position.y > 410 and position.y < 720:
					go_back_scene.emit()
					return false
			return true
		_:	
			return false


func _on_player_check_if_position_is_illegal(position):
	if illegal(position):
		stop_at_obstacle.emit()
