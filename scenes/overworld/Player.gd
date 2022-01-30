extends Node2D
const SPEED = 25
const DECELERATION = 4000
var x_decelerating = true
var y_decelerating = true

var is_in_hole = false
signal enter_battle(enemy_ant)

func at(x, y):
	position.x = x
	position.y = y
	return self
	
func set_animation(name):
	$KinematicBody2D/AnimatedSprite.animation = name

func area_entered(area):
	if area.get_name() == "Hole":
		print("entered hole", position)
		is_in_hole = true
	if area.get_name() == "BattleHitbox":
		var enemy = area.get_parent().get_parent()
		var ant = enemy.get_ant_object()
		var map = enemy.get_parent()
		map.remove_child(enemy)
		emit_signal("enter_battle", ant)

func area_exited(area):
	if area.get_name() == "Hole":
		print("left hole", position)
		is_in_hole = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$KinematicBody2D/AnimatedSprite/Camera2D.current = true
	$KinematicBody2D/Area2D.connect("area_entered", self, "area_entered")
	$KinematicBody2D/Area2D.connect("area_exited", self, "area_exited")
	position.x = 200
	position.y = 200

var up = false
var down = false
var left = false
var right = false

const FLOORS = 5
const FLOOR_ROOMS_WIDE = 10
const FLOOR_ROOMS_TALL = 10

const ROOM_TILES_WIDE = 10
const ROOM_TILES_TALL = 10

const TILE_WIDTH  = 100
const TILE_HEIGHT = 100


func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_SPACE and is_in_hole:
			position.x += FLOOR_ROOMS_WIDE * ROOM_TILES_WIDE * TILE_WIDTH
		if event.scancode == KEY_W:
			up = true
		if event.scancode == KEY_A:
			$KinematicBody2D/AnimatedSprite.flip_h = true
			left = true
		if event.scancode == KEY_S:
			down = true
		if event.scancode == KEY_D:
			$KinematicBody2D/AnimatedSprite.flip_h = false
			right = true
	if event is InputEventKey and not event.pressed:
		if event.scancode == KEY_W:
			up = false
		if event.scancode == KEY_A:
			left = false
		if event.scancode == KEY_S:
			down = false
		if event.scancode == KEY_D:
			right = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var x_vel = 0
	var y_vel = 0
	
	if left:  x_vel -= SPEED
	if right: x_vel += SPEED
	
	if up:    y_vel -= SPEED
	if down:  y_vel += SPEED
	$KinematicBody2D.move_and_collide(Vector2(x_vel, y_vel))
