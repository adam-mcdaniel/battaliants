extends Node2D

const Ant = preload("res://Ant.gd")
var Caste = Ant.new().Caste

func setup(ant, leftfacing=false):
	if ant.is_alive():
		$Label.text = "%s %d HP" % [ant.get_name(), ant.get_current_hp()]
	else:
		$Label.text = "%s - KO" % ant.get_name()
	$ProgressBar.value = float(ant.get_current_hp()) / ant.get_max_hp() * 100.0
	
	$AnimatedSprite.animation = ant.get_animation_name()
	
	if leftfacing:
		$AnimatedSprite.flip_h = true
