extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func at(x, y):
	$StaticBody2D.position.x = x
	$StaticBody2D.position.y = y
	return self

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
