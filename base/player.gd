extends TileMap

onready var start_pos = get_used_cells()[0]
onready var position = start_pos
onready var body = get_node("body")
var moves = 0
var moving = false
var move_dir = null

func _ready():
	print(start_pos)
	set_cellv(position, 5)
	body.set_pos(map_to_world(position) + Vector2(32, 32))
	set_process_input(true)
	set_fixed_process(true)

func _fixed_process(delta):
	if moving:
		var map_pos = map_to_world(position) + Vector2(32, 32)
		print(body.get_global_pos())
		if move_dir == "up":
			body.move(Vector2(0, -1) * 100 * delta)
			print(abs(body.get_global_pos().y - map_pos.y))
			if abs(body.get_global_pos().y - map_pos.y) >= 64:
				moving = false
				update_map_pos(Vector2(0, -1))
		elif move_dir == "down":
			body.move(Vector2(0, 1) * 100 * delta)
			print(abs(body.get_global_pos().y - map_pos.y))
			if abs(body.get_global_pos().y - map_pos.y) >= 64:
				moving = false
				update_map_pos(Vector2(0, 1))
		elif move_dir == "left":
			body.move(Vector2(-1, 0) * 100 * delta)
			print(abs(body.get_global_pos().x - map_pos.x))
			if abs(body.get_global_pos().x - map_pos.x) >= 64:
				moving = false
				update_map_pos(Vector2(-1, 0))
		elif move_dir == "right":
			body.move(Vector2(1, 0) * 100 * delta)
			print(abs(body.get_global_pos().x - map_pos.x))
			if abs(body.get_global_pos().x - map_pos.x) >= 64:
				moving = false
				update_map_pos(Vector2(1, 0))
				

func update_map_pos(pos):
	set_cellv(position, -1)
	position += pos
	set_cellv(position, 5)
	body.set_pos(map_to_world(position) + Vector2(32, 32))

func _input(event):
	if not moving:
		if event.is_action_pressed("ui_up"):
			moving = true
			move_dir = "up"
		elif event.is_action_pressed("ui_down"):
			moving = true
			move_dir = "down"
		elif event.is_action_pressed("ui_left"):
			moving = true
			move_dir = "left"
		elif event.is_action_pressed("ui_right"):
			moving = true
			move_dir = "right"
	
	print(get_used_cells())
	print(moves)
	