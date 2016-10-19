extends TileMap

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	print(get_cell(0,0))
	print(map_to_world(Vector2(1,0)))
	var tiles = get_tileset()
	print(tiles.tile_get_name(get_cell(2,1)))
	print(get_tree().get_nodes_in_group("player"))
	