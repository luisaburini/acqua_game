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
	Vector2(500, 600),
	Vector2(272, 566),
	Vector2(63, 512)
]
var return_positions = [
	Vector2(380, 470),
	Vector2(972, 593),
	Vector2(1118, 642)
]
var sebo_scenarios = ["res://img/cenario/sebo/sebo1.png",
					  "res://img/cenario/sebo/sebo2.png",
					  "res://img/cenario/sebo/sebo3.png"]
var chao_sebo = ["res://img/cenario/sebo/chao-sebo1.png",
			 	 "res://img/cenario/sebo/chao-sebo2.png",
				 "res://img/cenario/sebo/chao-sebo3.png"]
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
	update_objs_avoidance()
	update_objs_state()
	show()
	$Ismael.show()
		
func is_completed():
	return played_vinyl and $Inventory.check_if_item_exists("livro_magico")

func update_objs_avoidance():
	$Estante.set_avoidance_enabled(true)

func update_texture(limit):
	scenario_index = scenario_index+limit
	scenario_index = scenario_index%len(sebo_scenarios)
	$Background.texture = load(sebo_scenarios[scenario_index])
	$Chao.texture = load(chao_sebo[scenario_index])
	
func update_objs_state():
	$Dialogue.hide()
	var objs = [
		["Ismael", "Porta1"],
		[ "Vinyl", "Porta3"],
		["Gramophone", "Estante"]
	]
	for i in range(len(objs)):
		for o in objs[i]:
			var obj = get_node(o)
			if scenario_index == i:
				obj.show()
			else:
				obj.hide()
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
	if scenario_index == 2:
		if $Inventory.check_if_item_exists("vinyl") and $Inventory.check_if_item_exists("livro_magico") and played_vinyl:
			leave.emit()
			$AudioDica.stop()
		else:
			cannot_leave.emit()
	else:
		go_to_next_scene.emit()


func _on_dialogue_pressed_yes():
	$Dialogue.hide()
	$Inventory.add_item("livro_magico")


func _on_dialogue_pressed_no():
	$Dialogue.hide()


func _on_vinyl_pressed():
	$Vinyl.hide()
	$Inventory.add_item("vinyl")

func _on_ismael_clicked():
	_on_player_clicked_ismael()

func _on_player_clicked_ismael():
	will_show_dialogue.emit()
	$Dialogue.show()
	if $Inventory.check_if_item_exists("livro_magico"):
		$Dialogue.hide_interaction()
		$Dialogue.start_hide_timer()
		$Dialogue.change_texture("res://img/capybara-ismael.png")
		$Dialogue.change_label("Estou ocupado, desencosta")
	else:
		$Dialogue.change_texture("res://img/livro.png")
		$Dialogue.change_label("Gostaria de ganhar um livro mágico?")
		$Dialogue.show_interaction()
	
var first_click = true
func _unhandled_input(event):
	if event is InputEventScreenTouch and event.pressed == true:
		if first_click:
			first_click = false
			return
		if $Porta1.check_if_click_is_inside(event.position):
			print("Click is inside porta 1")
			print(event.position)
			go_to_next_scene.emit()
			return
		user_can_go_to.emit(event.position)
