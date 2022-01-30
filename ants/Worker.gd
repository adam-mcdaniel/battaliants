extends "res://Ant.gd"

func _ready():
	current_hp = 5
	max_hp = 5

func get_caste():
	return Caste.WORKER

func get_moves():
	return [Bite.new()]

func get_name():
	return "Worker"
