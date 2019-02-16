extends TileMap

const obj_bush = preload("res://Resources/Bush/Bush.tscn")
const obj_rock = preload("res://Resources/Rock/Rock.tscn")

func create_stuff(destination):
	for id in range(0, 5):
		for next_cell in get_used_cells_by_id(id):
			var new_bush = obj_bush.instance()
			new_bush.amount = CactusData.get_bush_amount(id)
			new_bush.position = map_to_world(next_cell)
			destination.add_child(new_bush)
	for id in range(5, 10):
		for next_cell in get_used_cells_by_id(id):
			var new_rock = obj_rock.instance()
			new_rock.amount = CactusData.get_rock_amount(id)
			new_rock.position = map_to_world(next_cell)
			destination.add_child(new_rock)
