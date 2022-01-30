extends "res://Ant.gd"

func _init():
	current_hp = 8
	max_hp = 8

func get_moves():
	return [Bite.new()]
	
func get_caste():
	return Caste.BUFF

func get_name():
	return "Buff"
