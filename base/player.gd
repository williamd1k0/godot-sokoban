extends TileMap

onready var position = get_used_cells()[0]
onready var body = get_node("body")
onready var anime = get_node("body/anime")

export var reference_tile = 5
export var base_speed = 100.0
export var move_size = 64
export var debug = false

var moving = false
var locked = false
var move_dir = null
var delta_ = 0

var direction = {
	"up": Vector2(0, -1),
	"down": Vector2(0, 1),
	"left": Vector2(-1, 0),
	"right": Vector2(1, 0)
}

signal move_request(dir, map_pos)
signal move_update(layer, new_pos, last_pos)

func _ready():
	set_cellv(position, reference_tile)
	body.move_to(map_to_world(position) + Vector2(move_size/2, move_size/2))
	body.set_hidden(false)
	set_fixed_process(true)

func _fixed_process(delta):
	delta_ = delta
	if locked:
		set_idle()
		return
	if not moving:
		input_update()
	else:
		check_move(direction[move_dir])

func lock():
	locked = true

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
		set_idle()

func set_idle():
	if "-" in anime.get_current_animation():
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
	var last_pos = position
	position += pos
	set_cellv(position, reference_tile)
	body.move_to(map_to_world(position) + Vector2(move_size/2, move_size/2))
	emit_signal("move_update", get_name(), position, last_pos)


func request_move(dir):
	emit_signal("move_request", dir, position)
	if debug:
		accept_move(dir, "walk")

func accept_move(dir, mode):
	move_dir = dir
	moving = true
	if anime.get_current_animation() != mode+"-"+dir:
		anime.play(mode+"-"+dir)

func stop_move(dir):
	anime.play("idle-"+dir)
	

func back_history(data):
	set_cellv(position, -1)
	position = data[1]
	set_cellv(position, reference_tile)
	locked = true
	anime.play("fadeout")


func _on_anime_finished():
	if anime.get_current_animation() == "fadeout":
		body.move_to(map_to_world(position) + Vector2(move_size/2, move_size/2))
		anime.play("fadein")
		locked = false
