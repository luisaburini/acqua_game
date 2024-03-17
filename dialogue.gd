extends Node

var is_hidden = false
signal pressed_yes
signal pressed_no
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func hide():
	is_hidden = true
	$Label.hide()
	$TextureButton.hide()
	$TouchYesButton.hide()
	$TouchNoButton.hide()
	
func show():
	is_hidden = false
	$Label.show()
	$TextureButton.show()
	$TouchYesButton.show()
	$TouchNoButton.show()

func change_label(text):
	$Label.text = text

func change_texture(texture_path):
	$TextureButton.texture_normal = load(texture_path)
	
func toggle_visibility():
	if is_hidden:
		show()
	else:
		hide()
		
func start_hide_timer():
	$HideInteractionTimer.start()
	
func hide_interaction():
	$TouchYesButton.hide()
	$TouchNoButton.hide()
	
func show_interaction():
	$TouchYesButton.show()
	$TouchNoButton.show()

func _on_yes_button_pressed():
	pressed_yes.emit()
	
func _on_no_button_pressed():
	pressed_no.emit()


func _on_hide_interaction_timer_timeout():
	hide()
