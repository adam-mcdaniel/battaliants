extends Node2D

const Wall = preload("res://scenes/overworld/Wall.tscn")
const Hole = preload("res://scenes/overworld/Hole.tscn")
const Player = preload("res://scenes/overworld/Player.tscn")
const Enemy = preload("res://scenes/overworld/Enemy.tscn")

const W = 0
const H = 1
const P = 2
const A = 3
const E = 4
const D = 5

const FLOORS = 5
const FLOOR_ROOMS_WIDE = 10
const FLOOR_ROOMS_TALL = 10

const ROOM_TILES_WIDE = 10
const ROOM_TILES_TALL = 10

const TILE_WIDTH  = 100
const TILE_HEIGHT = 100

onready var bgm = $AudioStreamPlayer
var volume = 100
var sfx = 100

var ROOMS = [
	[
		[W, W, W, W, E, E, W, W, W, W],
		[W, A, E, E, E, E, E, E, E, W],
		[W, E, E, E, E, E, E, E, E, W],
		[W, E, E, E, E, E, E, E, E, W],
		[E, E, E, E, E, E, E, E, E, E],
		[E, E, E, E, E, E, E, A, E, E],
		[W, E, E, E, E, E, E, E, E, W],
		[W, E, E, E, E, E, E, E, E, W],
		[W, E, E, E, E, E, E, E, E, W],
		[W, W, W, W, E, E, W, W, W, W],
	],
	[
		[W, W, W, W, E, E, W, W, W, W],
		[W, W, W, W, E, E, E, E, W, W],
		[W, W, W, W, E, E, E, W, W, W],
		[W, W, W, E, E, E, E, E, E, W],
		[E, E, E, E, E, E, E, E, E, E],
		[E, E, E, E, E, E, E, E, E, E],
		[W, W, E, E, E, E, W, W, E, W],
		[W, W, W, E, E, E, W, W, E, W],
		[W, W, W, E, E, E, E, W, W, W],
		[W, W, W, W, E, E, W, W, W, W],
	],
	[
		[W, W, W, W, E, E, W, W, W, W],
		[W, W, W, W, E, E, E, E, W, W],
		[W, W, W, W, E, E, E, W, W, W],
		[W, W, W, E, E, E, E, E, E, W],
		[E, E, E, E, E, E, E, E, E, E],
		[E, E, E, E, A, E, E, E, E, E],
		[W, W, E, E, E, E, W, W, E, W],
		[W, W, W, E, E, E, W, W, E, W],
		[W, W, W, E, E, E, E, W, W, W],
		[W, W, W, W, E, E, W, W, W, W],
	],
	[
		[W, W, W, W, W, W, W, W, W, W],
		[W, W, W, W, W, W, W, W, W, W],
		[W, W, W, W, W, E, E, W, W, W],
		[W, W, W, W, E, E, E, E, W, W],
		[E, E, E, E, E, E, E, E, E, E],
		[E, E, E, E, E, E, E, E, E, E],
		[W, W, E, E, E, E, W, W, E, W],
		[W, W, W, E, W, W, W, W, E, W],
		[W, W, W, E, E, W, W, W, W, W],
		[W, W, W, W, W, W, W, W, W, W],
	],
	[
		[W, W, W, W, W, W, W, W, W, W],
		[W, W, W, W, W, W, W, W, W, W],
		[W, W, W, W, W, E, E, W, W, W],
		[W, W, W, W, E, E, E, E, W, W],
		[E, E, E, E, E, E, E, E, E, E],
		[E, E, E, E, A, E, E, E, E, E],
		[W, W, E, E, E, E, W, W, E, W],
		[W, W, W, E, E, W, W, W, E, W],
		[W, W, W, E, E, E, W, W, W, W],
		[W, W, W, E, E, E, W, W, W, W],
	],
	[
		[W, W, W, W, E, E, W, W, W, W],
		[W, W, W, W, E, E, E, E, W, W],
		[W, W, W, W, E, E, E, W, W, W],
		[W, W, W, E, E, E, E, E, E, W],
		[W, W, E, E, E, E, E, E, W, W],
		[W, W, E, E, E, E, E, W, W, W],
		[W, W, E, E, E, E, W, W, W, W],
		[W, W, W, E, E, E, W, W, W, W],
		[W, W, W, E, E, E, E, W, W, W],
		[W, W, W, W, E, E, W, W, W, W],
	],
	[
		[W, W, W, W, E, E, W, W, W, W],
		[W, W, W, W, E, E, E, E, W, W],
		[W, W, E, E, E, E, E, W, W, W],
		[W, W, E, E, E, E, E, E, E, W],
		[E, E, E, E, E, E, E, E, W, W],
		[E, E, E, E, E, E, E, W, W, W],
		[W, W, E, E, E, E, W, W, W, W],
		[W, W, W, E, E, E, W, W, W, W],
		[W, W, W, E, E, W, W, W, W, W],
		[W, W, W, W, W, W, W, W, W, W],
	],
	[
		[W, W, W, W, E, E, W, W, W, W],
		[W, W, W, W, E, E, E, E, W, W],
		[W, W, E, E, E, E, E, W, W, W],
		[W, W, E, E, E, E, E, E, E, W],
		[E, E, E, E, A, E, E, E, W, W],
		[E, E, E, W, E, E, E, W, W, W],
		[W, W, E, W, E, E, W, W, W, W],
		[W, W, W, E, E, E, W, W, W, W],
		[W, W, W, E, E, E, W, W, W, W],
		[W, W, W, W, E, E, E, W, W, W],
	],
	[
		[W, W, W, W, W, W, W, W, W, W],
		[W, W, W, W, E, E, E, E, W, W],
		[W, W, E, E, E, E, E, W, W, W],
		[W, W, E, E, E, E, E, E, E, W],
		[E, E, E, E, H, E, E, E, W, W],
		[E, E, E, E, E, E, E, W, W, W],
		[W, W, E, E, E, E, W, W, W, W],
		[W, W, W, E, E, W, W, W, W, W],
		[W, W, W, E, E, E, W, W, W, W],
		[W, W, W, W, E, E, W, W, W, W],
	],
	[
		[W, W, W, W, W, W, W, W, W, W],
		[W, W, W, W, E, E, E, E, W, W],
		[W, W, E, E, E, A, E, W, W, W],
		[W, W, E, E, E, E, W, W, E, W],
		[E, E, E, E, E, E, E, E, E, E],
		[E, E, E, E, E, H, E, E, E, E],
		[W, W, E, E, A, E, W, W, W, W],
		[W, W, W, E, E, W, W, W, W, W],
		[W, W, W, E, E, E, W, W, W, W],
		[W, W, W, W, E, E, W, W, W, W],
	],
	[
		[W, W, W, W, E, E, W, W, W, W],
		[W, W, W, W, E, E, E, E, W, W],
		[W, W, W, E, E, A, E, W, W, W],
		[W, W, W, E, E, E, E, E, E, W],
		[W, W, E, E, E, E, E, E, W, E],
		[W, W, E, E, H, E, E, W, W, E],
		[W, W, E, E, A, E, W, W, W, W],
		[W, W, W, E, E, W, W, W, W, W],
		[W, W, W, E, E, E, W, W, W, W],
		[W, W, W, W, E, E, W, W, W, W],
	],
	[
		[W, W, W, W, E, E, W, W, W, W],
		[W, W, W, W, E, E, E, E, W, W],
		[W, W, E, E, E, A, E, W, W, W],
		[W, W, E, E, E, E, E, E, E, W],
		[E, E, E, E, E, E, E, E, W, E],
		[E, E, E, E, A, E, E, W, W, E],
		[W, W, E, E, E, E, W, W, W, W],
		[W, W, W, E, E, E, W, W, W, W],
		[W, W, W, W, E, E, W, W, W, W],
		[W, W, W, W, W, W, W, W, W, W],
	],
]

var ORIGIN = [
	[W, W, W, W, E, E, W, W, W, W],
	[W, A, E, E, E, E, E, E, E, W],
	[W, E, E, E, E, E, E, E, E, W],
	[W, E, E, E, E, E, E, E, E, W],
	[E, E, E, E, P, E, E, E, E, E],
	[E, E, E, E, E, E, E, E, E, E],
	[W, E, E, E, E, E, E, E, E, W],
	[W, E, E, E, E, E, E, E, E, W],
	[W, E, E, E, E, E, E, E, E, W],
	[W, W, W, W, E, E, W, W, W, W],
]

var player = null

func start_battle(player_party, enemy_party):
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	load_settings()
	bgm.volume_db = volume
	for floor_num in range(FLOORS):
		for room_x in range(-FLOOR_ROOMS_WIDE/2, FLOOR_ROOMS_WIDE/2):
			for x in range(ROOM_TILES_WIDE):
				var pixel_x = floor_num * FLOOR_ROOMS_WIDE * ROOM_TILES_WIDE * TILE_WIDTH + (room_x * ROOM_TILES_WIDE + x) * TILE_WIDTH
				var top_pixel_y = ((FLOOR_ROOMS_TALL/2-1) * ROOM_TILES_TALL + ROOM_TILES_TALL) * TILE_HEIGHT
				var bottom_pixel_y = -FLOOR_ROOMS_TALL/2 * ROOM_TILES_TALL * TILE_HEIGHT
				add_child(Wall.instance().at(pixel_x, top_pixel_y))
				add_child(Wall.instance().at(pixel_x, bottom_pixel_y))
	for floor_num in range(FLOORS):
		for room_y in range(-FLOOR_ROOMS_TALL/2, FLOOR_ROOMS_TALL/2):
			for y in range(ROOM_TILES_TALL):
				var pixel_y = (room_y * ROOM_TILES_TALL + y) * TILE_HEIGHT
				var left_pixel_x = floor_num * FLOOR_ROOMS_WIDE * ROOM_TILES_WIDE * TILE_WIDTH + (-FLOOR_ROOMS_TALL/2) * ROOM_TILES_WIDE * TILE_WIDTH
				var right_pixel_x = floor_num * FLOOR_ROOMS_WIDE * ROOM_TILES_WIDE * TILE_WIDTH + ((FLOOR_ROOMS_WIDE/2-1) * ROOM_TILES_WIDE + ROOM_TILES_WIDE) * TILE_WIDTH
				add_child(Wall.instance().at(left_pixel_x, pixel_y))
				add_child(Wall.instance().at(right_pixel_x, pixel_y))

	for floor_num in range(FLOORS):
		for room_x in range(-FLOOR_ROOMS_WIDE/2, FLOOR_ROOMS_WIDE/2):
			for room_y in range(-FLOOR_ROOMS_TALL/2, FLOOR_ROOMS_TALL/2):
				var room = ROOMS[randi() % len(ROOMS)]
				if floor_num == 0 and room_x == 0 and room_y == 0:
					room = ORIGIN
				
				for x in range(ROOM_TILES_WIDE):
					for y in range(ROOM_TILES_TALL):
						var pixel_x = floor_num * FLOOR_ROOMS_WIDE * ROOM_TILES_WIDE * TILE_WIDTH + (room_x * ROOM_TILES_WIDE + x) * TILE_WIDTH
						var pixel_y = (room_y * ROOM_TILES_TALL + y) * TILE_HEIGHT
						match room[y][x]:
							W: add_child(Wall.instance().at(pixel_x, pixel_y))
							H: add_child(Hole.instance().at(pixel_x, pixel_y))
							A: add_child(Enemy.instance().at(pixel_x, pixel_y))
	
	for floor_num in range(FLOORS):
		for room_x in range(-FLOOR_ROOMS_WIDE/2, FLOOR_ROOMS_WIDE/2):
			for room_y in range(-FLOOR_ROOMS_TALL/2, FLOOR_ROOMS_TALL/2):
				var room = ROOMS[randi() % len(ROOMS)]
				if floor_num == 0 and room_x == 0 and room_y == 0:
					room = ORIGIN
				
				for x in range(ROOM_TILES_WIDE):
					for y in range(ROOM_TILES_TALL):
						var pixel_x = floor_num * FLOOR_ROOMS_WIDE * ROOM_TILES_WIDE * TILE_WIDTH + (room_x * ROOM_TILES_WIDE + x) * TILE_WIDTH
						var pixel_y = (room_y * ROOM_TILES_TALL + y) * TILE_HEIGHT
						match room[y][x]:
							P:
								player = Player.instance().at(pixel_x, pixel_y)
								add_child(player)
							_: pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func load_settings():
	var config = ConfigFile.new()
	config.load("settings.cfg")
	sfx = config.get_value("set", "fx", 100)
	volume = config.get_value("set", "music", 100)
	if sfx == 0:
		sfx = -80
	else:
		sfx = -30 * (1-sfx/100)
	if volume == 0:
		volume == -80
	else:
		volume = -30 * (1-volume/100)
