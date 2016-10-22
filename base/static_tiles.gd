extends TileMap


export var passable_tiles = [1, 2]


func _ready():
	print(get_cells_by_id(0))


func is_passable(x, y):
	return get_cell(x, y) in passable_tiles or get_cell(x, y) == -1

func is_passablev(tilev):
	return get_cellv(tilev) in passable_tiles or get_cellv(tilev) == -1

func get_cells_by_id(id):
	var cells = []
	for pos in get_used_cells():
		if get_cellv(pos) == id:
			cells.append(pos)
	return cells
	