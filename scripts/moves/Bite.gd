class_name Bite
extends "res://Move.gd"

var power = 60
func perform(battle_state, caster, target=null, opposing_ant=null):
	print("*munch*")
	target.take_damage(damage_calc(power, caster.get_attack(), target.get_defense()))

func get_name():
	return "Bite"
