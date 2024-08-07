extends Node

enum ITEM_TYPE {vinyl, livro_magico, pagina_morro, pagina_praca}

var items_list = []

func reset():
	items_list = []

func add_item(item):
	items_list.append(item)
		
func check_if_item_exists(item):
	for it in items_list:
		if it == item:
			return true
	return false
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
