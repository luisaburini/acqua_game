extends StaticBody2D

signal user_can_go_to(position)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func check_if_click_is_inside(position):
	if position.x > 208-451/2 and position.y > 226.5-402/2:
		if position.x < 208+451/2 and position.y < 226.5+402/2:
			return true
	return false
