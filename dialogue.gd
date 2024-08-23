extends CanvasLayer


signal pressed_yes
signal pressed_no
var started = false
signal player_go_to(pos)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hide_all():
	get_viewport().physics_object_picking_sort = false
	started = false
	$TextureRect.hide()
	$Label.hide()
	$Image.hide()
	$TouchYesButton.hide()
	$TouchNoButton.hide()
	
func show_all():
	get_viewport().physics_object_picking_sort = true
	started = true
	$TextureRect.show()
	$Label.show()
	$Image.show()
	$TouchYesButton.show()
	$TouchNoButton.show()

func change_label(text):
	$Label.text = text

func change_texture(texture_path):
	$Image.texture = load(texture_path)
	
func hide_interaction():
	$TouchNoButton.hide()
	
func show_interaction():
	$TouchYesButton.show()
	$TouchNoButton.show()

var ignore_click = false

func _on_yes_button_pressed():
	ignore_click = true
	hide_all()
	pressed_yes.emit()
	
func _on_no_button_pressed():
	ignore_click = true
	hide_all()
	pressed_no.emit()
	


func _unhandled_input(event):
	if event is InputEventScreenTouch and event.pressed == true:
		if started:
			get_viewport().set_input_as_handled()
		else:
			if ignore_click:
				get_viewport().set_input_as_handled()
				ignore_click = false
			else:
				# print("Dialogue: Player go to " + str(event.position.x) + " " + str(event.position.y))
				player_go_to.emit(event.position)
