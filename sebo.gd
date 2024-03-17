extends CanvasLayer

signal leave
signal cannot_leave
signal stop_music
signal will_show_dialogue
var scenario_index = 0
var sebo_scenarios = ["res://img/sebo1.jpg",
					  "res://img/sebo2.jpg",
					  "res://img/sebo3.jpg"]
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
	$Ismsael.hide()
	$Vinyl.hide()
	$Gramophone.hide()
	hide()
	
func start():
	scenario_index = 0
	update_objs_state()
	show()
	$TextureRect.show()
		
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
	if scenario_index == 0:
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
