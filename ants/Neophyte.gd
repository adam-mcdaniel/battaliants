extends "res://Ant.gd"

func get_moves():
	return [Bite.new()]
	
func get_caste():
	return Caste.NEOPHYTE

func get_name():
	return "Neophyte"
