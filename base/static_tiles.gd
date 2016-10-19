extends TileMap


export var passable_tiles = [1]


func _ready():
	pass


func is_passable(tilev):
	return get_cellv(tilev) in passable_tiles
	