class_name Bite
extends "res://Move.gd"

func perform(battle_state, caster, target=null, opposing_ant=null):
	print("*munch*")
	target.take_damage(2)

func get_name():
	return "Bite"
