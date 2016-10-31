extends KinematicBody2D

var queue_move = null

func _ready():
	pass

func rewind_to(to_pos):
	queue_move = to_pos
	get_node("anime").play("fadeout")
	

func _on_anime_finished():
	if get_node("anime").get_current_animation() == "fadeout":
		move_to(queue_move)
		get_node("anime").play("fadein")
