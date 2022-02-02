extends "res://scripts/Ant.gd"

var Hatch = load("res://scripts/moves/Hatch.gd")
var moves = [Hatch.new()]

func _init():
	current_hp = 10
	max_hp = 1

func get_caste():
	return Caste.LARVAE
	
func get_moves():
	return moves
	
func set_moves(moves):
	self.moves = moves

func get_name():
	return "Larvae"
