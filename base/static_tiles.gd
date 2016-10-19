extends TileMap


export var passable_tiles = [1]


func _ready():
	pass


func is_passable(x, y):
	return get_cell(x, y) in passable_tiles

func is_passablev(tilev):
	return get_cellv(tilev) in passable_tiles