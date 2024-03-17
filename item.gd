extends Node

enum ITEM_TYPE {vinyl, livro, pagina_morro, pagina_praca}

class Inventory:
	var items_list = []

	func _init():
		pass
	func add_item(item):
		items_list.append(item)
		
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
