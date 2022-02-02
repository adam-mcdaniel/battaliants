class_name Hatch
extends "res://Move.gd"

var Worker = load("res://scripts/Worker.gd")

var turns_left = 3

func perform(battle_state, caster, target=null, opposing_ant=null):
	turns_left -= 1
	if turns_left == 0:
		print("hatched into a new ant!")
		if battle_state.is_player_turn:
			battle_state.player_ant = Worker.new()
		else:
			battle_state.enemy_ant = Worker.new()
	else:
		print("*crack*")

func uses_target():
	return false

func get_name():
	return "Hatch (%d turns remaining)" % turns_left
