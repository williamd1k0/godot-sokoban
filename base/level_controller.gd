extends Node2D

onready var static_tiles = get_node("StaticTiles")
onready var player = get_node("Player")

func _ready():
	pass


func can_pass(dir, map_pos):
	if dir == "up":
		return static_tiles.is_passable(map_pos.x, map_pos.y-1)
	elif dir == "down":
		return static_tiles.is_passable(map_pos.x, map_pos.y+1)
	elif dir == "left":
		return static_tiles.is_passable(map_pos.x-1, map_pos.y)
	elif dir == "right":
		return static_tiles.is_passable(map_pos.x+1, map_pos.y)


func _on_Player_move_request( dir, map_pos ):
	if can_pass(dir, map_pos):
		player.accept_move(dir)
	else:
		print("Cant Pass!!")
