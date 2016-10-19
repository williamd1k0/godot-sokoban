extends TileMap

export var block_id = 3

func _ready():
	for block in get_used_cells():
		pass

func push_blockv(map_pos, to_pos):
	set_cellv(map_pos, -1)
	set_cellv(to_pos, block_id)

func has_block(pos):
	return get_cellv(pos) != -1
