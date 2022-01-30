extends Node2D


const Worker = preload("res://ants/Worker.gd")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal choose_starter(starter)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

signal choose_start(ant)

func _on_leafselect_pressed():
	var ant = Worker.new()
	ant.current_hp += 10
	ant.species = ant.Species.LEAFCUTTER
	emit_signal("choose_starter", ant)

func _on_bulletselect_pressed():
	var ant = Worker.new()
	ant.current_hp += 10
	ant.species = ant.Species.BULLET
	emit_signal("choose_starter", ant)

func _on_fireselect_pressed():
	var ant = Worker.new()
	ant.current_hp += 10
	ant.species = ant.Species.FIRE
	emit_signal("choose_starter", ant)

func _on_crazyselect_pressed():
	var ant = Worker.new()
	ant.current_hp += 10
	ant.species = ant.Species.CRAZY
	emit_signal("choose_starter", ant)
	
