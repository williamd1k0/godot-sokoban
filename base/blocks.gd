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

var direction = {
	"up": Vector2(0, -1),
	"down": Vector2(0, 1),
	"left": Vector2(-1, 0),
	"right": Vector2(1, 0)
}

signal block_push(layer, new_pos, last_pos)

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
		check_move(direction[move_dir])

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
	blocks[moving_block].move_to(map_to_world(to_pos) + Vector2(move_size/2, move_size/2))
	blocks[to_pos] = blocks[moving_block]
	blocks.erase(moving_block)
	emit_signal("block_push", get_name(), to_pos, moving_block)


func back_history(data):
	print(data)
	print(blocks)
	set_cellv(data[0], -1)
	set_cellv(data[1], reference_id)
	blocks[data[0]].rewind_to(map_to_world(data[1]) + Vector2(move_size/2, move_size/2))
	blocks[data[1]] = blocks[data[0]]
	blocks.erase(data[0])
	