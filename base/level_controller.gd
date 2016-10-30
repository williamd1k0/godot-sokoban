extends Node2D

onready var static_tiles = get_tree().get_nodes_in_group("static-layer")
onready var player = get_node("Player")
onready var blocks = get_node("Blocks")

export var slot_id = 1
export(NodePath) var slot_tilemap
var slots = null
var slot_count = 0
var filled_slots = 0
var move_count = 0
var pushing = false
var game_layers = null
var game_history = []

var direction = {
	"up": Vector2(0, -1),
	"down": Vector2(0, 1),
	"left": Vector2(-1, 0),
	"right": Vector2(1, 0)
}

signal start(slots_left)
signal solved
signal update(slots_left, moves)

func _ready():
	slots = get_slots()
	slot_count = slots.size()
	game_layers = {
		player.get_name(): player,
		blocks.get_name(): blocks
	}
	push_history()
	set_process_input(true)
	emit_signal("start", slot_count)

func push_history():
	for layer in game_layers.keys():
		update_history(layer)


func update_history(layer):
	if game_history.size() <= move_count:
		game_history.append({})
	game_history[move_count][layer] = game_layers[layer].get_history()
	print(game_history)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if game_history.size() <= 1:
			return
		print(game_history[-1])
		move_count -= 1
		for layer in game_history[-1].keys():
			game_layers[layer].back_history(game_history[-1][layer])
		game_history.pop_back()
		print("Rewind not implemented")

func get_slots():
	return get_node(slot_tilemap).get_cells_by_id(slot_id)


func is_passable(map_pos):
	for layer in static_tiles:
		if not layer.is_passablev(map_pos):
			return false
	return true

func can_pass(dir, map_pos):
	var map_posv = map_pos + direction[dir]
	map_posv = map_pos + direction[dir]
	if blocks.has_block(map_posv):
		return check_push(map_posv, map_posv + direction[dir], dir)
	if is_passable(map_posv):
		return true
	return false

func check_push(pos, to_pos, dir):
	print("Cheking push")
	if not blocks.has_block(to_pos) and is_passable(to_pos):
		pushing = true
		blocks.push_blockv(pos, to_pos, dir)
		return true
	return false

func _on_Player_move_request( dir, map_pos ):
	pushing = false
	if can_pass(dir, map_pos):
		move_count += 1
		if pushing:
			player.accept_move(dir, "push")
		else:
			player.accept_move(dir, "walk")
	else:
		player.stop_move(dir)


func check_slots():
	print("Slots: "+str(filled_slots))
	if filled_slots == slot_count:
		emit_signal("solved")

func _on_Blocks_block_push( layer ):
	update_history(layer)
	filled_slots = 0
	for slot in slots:
		if blocks.has_block(slot):
			filled_slots += 1
	emit_signal("update", slot_count - filled_slots, move_count)
	check_slots()


func _on_Player_move_update( layer ):
	update_history(layer)
	print(move_count)
	emit_signal("update", slot_count - filled_slots, move_count)
