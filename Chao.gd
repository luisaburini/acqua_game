extends Button

var clicked_position = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_clicked_position():
	return clicked_position

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			clicked_position = event.position
			
			
