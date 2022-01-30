extends "res://Ant.gd"

func _init():
	current_hp = 10
	max_hp = 10

func get_caste():
	return Caste.QUEEN

func get_moves():
	return [Bite.new(), Feed.new()]

func get_name():
	return "Queen"
