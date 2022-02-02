class_name Feed
extends "res://Move.gd"

func perform(battle_state, caster, target=null, opposing_ant=null):
	print("here, take this!!!")
	target.heal_hp(1)

func get_name():
	return "Feed"

func is_benevolent():
	return true
