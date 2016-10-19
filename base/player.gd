extends TileMap

onready var start_pos = get_used_cells()[0]
onready var position = start_pos
var moves = 0

func _ready():
	print(start_pos)
	set_cellv(position, -1)
	set_process_input(true)

func _input(event):

	if event.is_action_pressed("ui_up"):
		position.y -= 1
		moves += 1
	elif event.is_action_pressed("ui_down"):
		position.y += 1
		moves += 1
	elif event.is_action_pressed("ui_left"):
		position.x -= 1
		moves += 1
	elif event.is_action_pressed("ui_right"):
		position.x += 1
		moves += 1
	
	#set_cellv(position, 4)
	
	print(moves)