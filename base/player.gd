extends TileMap

onready var start_pos = get_used_cells()[0]
onready var position = start_pos
onready var body = get_node("body")
onready var anime = get_node("body/anime")

export var reference_tile = 5
export var base_speed = 100.0
export var move_size = 64
export var debug = false

var moves = 0
var moving = false
var move_dir = null
var move_log = []
var delta_ = 0

signal move_request(dir, map_pos)
signal move_update

func _ready():
	set_cellv(position, reference_tile)
	body.set_pos(map_to_world(position) + Vector2(move_size/2, move_size/2))
	body.set_hidden(false)
	set_fixed_process(true)

func _fixed_process(delta):
	delta_ = delta
	if not moving:
		input_update()
	else:
		if move_dir == "up":
			check_move(Vector2(0, -1))
		elif move_dir == "down":
			check_move(Vector2(0, 1))
		elif move_dir == "left":
			check_move(Vector2(-1, 0))
		elif move_dir == "right":
			check_move(Vector2(1, 0))

func input_update():
	if Input.is_action_pressed("ui_up"):
		request_move("up")
	elif Input.is_action_pressed("ui_down"):
		request_move("down")
	elif Input.is_action_pressed("ui_left"):
		request_move("left")
	elif Input.is_action_pressed("ui_right"):
		request_move("right")
	else:
		anime.play("idle-"+anime.get_current_animation().split("-")[1])

func check_move(move):
	var map_pos = map_to_world(position) + Vector2(move_size/2, move_size/2)
	var map_index = 0
	var global_index = 0
	if move.x != 0:
		map_index = map_pos.x
		global_index = body.get_global_pos().x
	else:
		map_index = map_pos.y
		global_index = body.get_global_pos().y
		
	body.move(move * base_speed * delta_)
	if abs(global_index - map_index) >= move_size:
		moving = false
		update_map_pos(move)


func update_map_pos(pos):
	set_cellv(position, -1)
	move_log.append(position)
	position += pos
	set_cellv(position, reference_tile)
	body.set_pos(map_to_world(position) + Vector2(move_size/2, move_size/2))
	emit_signal("move_update")


func request_move(dir):
	emit_signal("move_request", dir, position)
	if debug:
		accept_move(dir)

func accept_move(dir):
	move_dir = dir
	moving = true
	if anime.get_current_animation() != "walk-"+dir:
		anime.play("walk-"+dir)

func back_log():
	if move_log.size() > 0:
		set_cellv(position, -1)
		position = move_log[-1]
		set_cellv(position, reference_tile)
		body.set_pos(map_to_world(position) + Vector2(move_size/2, move_size/2))
		move_log.pop_back()
	