extends TileMap

export(String, FILE, "*.tscn") var block_base
export var block_id = 0
export var reference_id = 1
export var move_size = 64
export var base_speed = 70
var blocks = {}
var moving_block = null
var moving = false
var move_dir = null
var delta_ = null

signal block_push

func _ready():
	for block in get_used_cells():
		blocks[block] = load(block_base).instance()
		blocks[block].set_hidden(false)
		blocks[block].set_pos(map_to_world(block) + Vector2(move_size/2, move_size/2))
		add_child(blocks[block])
		set_cellv(block, reference_id)
	print(blocks)
	set_fixed_process(true)

func _fixed_process(delta):
	delta_ = delta
	if moving:
		if move_dir == "up":
			check_move(Vector2(0, -1))
		elif move_dir == "down":
			check_move(Vector2(0, 1))
		elif move_dir == "left":
			check_move(Vector2(-1, 0))
		elif move_dir == "right":
			check_move(Vector2(1, 0))

func has_block(pos):
	return get_cellv(pos) != -1

func push_blockv(map_pos, to_pos, dir):
	move_dir = dir
	moving_block = map_pos
	moving = true

func check_move(move):
	var map_pos = map_to_world(moving_block) + Vector2(move_size/2, move_size/2)
	var map_index = 0
	var global_index = 0
	if move.x != 0:
		map_index = map_pos.x
		global_index = blocks[moving_block].get_global_pos().x
	else:
		map_index = map_pos.y
		global_index = blocks[moving_block].get_global_pos().y
		
	blocks[moving_block].move(move * base_speed * delta_)
	if abs(global_index - map_index) >= move_size:
		moving = false
		update_map_pos(move)

func update_map_pos(move):
	var to_pos = moving_block + move
	set_cellv(moving_block, -1)
	set_cellv(to_pos, reference_id)
	blocks[moving_block].set_pos(map_to_world(to_pos) + Vector2(move_size/2, move_size/2))
	blocks[to_pos] = blocks[moving_block]
	blocks.erase(moving_block)
	emit_signal("block_push")

func get_history():
	var history = []
	for block in blocks.keys():
		#print(world_to_map(blocks[block].get_pos()))
		#print(get_cellv(world_to_map(blocks[block].get_pos())))
		history.append([block, world_to_map(blocks[block].get_pos())])
	return history


# REWIND TODO
func back_history(data):
	pass

func back_log():
	for block in blocks.keys():
		if blocks[block].move_log.size() > 0:
			set_cellv(block, -1)
			set_cellv(blocks[block].move_log[-1], reference_id)
			blocks[block].set_pos(map_to_world(blocks[block].move_log[-1]) + Vector2(move_size/2, move_size/2))
			blocks[block].move_log.pop_back()


