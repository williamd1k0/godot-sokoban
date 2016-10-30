extends Node2D

var slots_left = 0

func _ready():
	pass

func update_slots_left(slots):
	get_node("left").set_text("Left: "+str(slots))

func update_moves(moves):
	get_node("moves").set_text("Moves: "+str(moves))
	
func _on_LevelController_start( slots_left_ ):
	slots_left = slots_left_
	update_slots_left(slots_left)
	update_moves(0)

func _on_LevelController_solved():
	get_node("gameover").set_hidden(false)

func _on_LevelController_update( slots_left_, moves ):
	update_moves(moves)
	if slots_left != slots_left_:
		slots_left = slots_left_
		update_slots_left(slots_left)
		print(moves)
