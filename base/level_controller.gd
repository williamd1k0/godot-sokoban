extends Node2D

onready var static_tiles = get_tree().get_nodes_in_group("static-layer")
onready var player = get_node("Player")
onready var blocks = get_node("Blocks")

export var slot_id = 1
export(NodePath) var slot_tilemap
var slots = null
var slot_count = 0
var filled_slots = 0

signal start(slots_left)
signal solved
signal update(slots_left)

func _ready():
	slots = get_slots()
	slot_count = slots.size()
	emit_signal("start", slot_count)

func get_slots():
	return get_node(slot_tilemap).get_cells_by_id(slot_id)


func is_passable(map_pos):
	for layer in static_tiles:
		if not layer.is_passablev(map_pos):
			return false
	return true

func can_pass(dir, map_pos):
	var map_posv = null
	if dir == "up":
		map_posv = Vector2(map_pos.x, map_pos.y-1)
		if blocks.has_block(map_posv):
			return check_push(map_posv, Vector2(map_posv.x, map_posv.y-1))
		if is_passable(map_posv):
			return true
			
	elif dir == "down":
		map_posv = Vector2(map_pos.x, map_pos.y+1)
		if blocks.has_block(map_posv):
			return check_push(map_posv, Vector2(map_posv.x, map_posv.y+1))
		if is_passable(map_posv):
			return true
			
	elif dir == "left":
		map_posv = Vector2(map_pos.x-1, map_pos.y)
		if blocks.has_block(map_posv):
			return check_push(map_posv, Vector2(map_posv.x-1, map_posv.y))
		if is_passable(map_posv):
			return true
			
	elif dir == "right":
		map_posv = Vector2(map_pos.x+1, map_pos.y)
		if blocks.has_block(map_posv):
			return check_push(map_posv, Vector2(map_posv.x+1, map_posv.y))
		if is_passable(map_posv):
			return true
	return false

func check_push(pos, to_pos):
	print("Cheking push")
	if not blocks.has_block(to_pos) and is_passable(to_pos):
		blocks.push_blockv(pos, to_pos)
		return true
	return false

func _on_Player_move_request( dir, map_pos ):
	if can_pass(dir, map_pos):
		player.accept_move(dir)
	else:
		print("Cant Pass!!")

func check_slots():
	print("Slots: "+str(filled_slots))
	if filled_slots == slot_count:
		emit_signal("solved")

func _on_Blocks_block_push():
	filled_slots = 0
	for slot in slots:
		if blocks.has_block(slot):
			filled_slots += 1
	if filled_slots > 0:
		emit_signal("update", slot_count - filled_slots)
	check_slots()

