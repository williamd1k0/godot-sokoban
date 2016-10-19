extends Node2D

onready var static_tiles = get_node("StaticTiles")
onready var player = get_node("Player")
onready var blocks = get_node("Blocks")

func _ready():
	pass


func can_pass(dir, map_pos):
	var map_posv = null
	if dir == "up":
		map_posv = Vector2(map_pos.x, map_pos.y-1)
		if blocks.has_block(map_posv):
			return check_push(map_posv, Vector2(map_posv.x, map_posv.y-1))
		if static_tiles.is_passablev(map_posv):
			return true
			
	elif dir == "down":
		map_posv = Vector2(map_pos.x, map_pos.y+1)
		if blocks.has_block(map_posv):
			return check_push(map_posv, Vector2(map_posv.x, map_posv.y+1))
		if static_tiles.is_passablev(map_posv):
			return true
			
	elif dir == "left":
		map_posv = Vector2(map_pos.x-1, map_pos.y)
		if blocks.has_block(map_posv):
			return check_push(map_posv, Vector2(map_posv.x-1, map_posv.y))
		if static_tiles.is_passablev(map_posv):
			return true
			
	elif dir == "right":
		map_posv = Vector2(map_pos.x+1, map_pos.y)
		if blocks.has_block(map_posv):
			return check_push(map_posv, Vector2(map_posv.x+1, map_posv.y))
		if static_tiles.is_passablev(map_posv):
			return true
	return false

func check_push(pos, to_pos):
	print("Cheking push")
	if not blocks.has_block(to_pos) and static_tiles.is_passablev(to_pos):
		blocks.push_blockv(pos, to_pos)
		return true
	return false

func _on_Player_move_request( dir, map_pos ):
	if can_pass(dir, map_pos):
		player.accept_move(dir)
	else:
		print("Cant Pass!!")
