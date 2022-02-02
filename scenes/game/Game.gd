extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const BattleScene = preload("res://scenes/battle/BattleScene.tscn")
onready var battle_scene = BattleScene.instance()

const MapScene = preload("res://scenes/overworld/Map.tscn")
onready var map_scene = MapScene.instance()

const StartScene = preload("res://scenes/starterselection/StarterSelection.tscn")
onready var start_scene = StartScene.instance()

const Larvae = preload("res://scripts/Larvae.gd")
const Worker = preload("res://scripts/Worker.gd")
const Queen = preload("res://scripts/Queen.gd")

var player_party = []

var is_in_overworld = true


# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(start_scene)
	start_scene.connect("choose_starter", self, "_on_Node2D_choose_starter")
	battle_scene.connect("won_battle", self, "_on_Node2D_won_battle")
	
func _process(delta):
	if map_scene.player != null:
		map_scene.player.connect("enter_battle", self, "_on_Node2D_enter_battle")
		if not player_party.empty():
			map_scene.player.set_animation(player_party[0].get_animation_name())
#	var lifebar_node = get_node('UserInterface/Lifebar')
#
#	character_node.connect("health_changed", lifebar_node, "_on_Character_health_changed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Node2D_enter_battle(enemy_ant):
	map_scene.player.up = false
	map_scene.player.down = false
	map_scene.player.left = false
	map_scene.player.right = false
	remove_child(map_scene)
	battle_scene.start_battle(player_party, [enemy_ant])
	add_child(battle_scene)

func _on_Node2D_won_battle(modified_player_party, last_enemy_ant):
	player_party = modified_player_party
	if randi() % 2 and len(player_party) < 6:
		last_enemy_ant.current_hp = last_enemy_ant.max_hp
		player_party.append(last_enemy_ant)
	remove_child(battle_scene)
	battle_scene = BattleScene.instance()
	battle_scene.connect("won_battle", self, "_on_Node2D_won_battle")
	battle_scene.connect("lost_battle", self, "_on_Node2D_lost_battle")
	add_child(map_scene)

func _on_Node2D_lost_battle():
	remove_child(battle_scene)
	battle_scene = BattleScene.instance()
	battle_scene.connect("won_battle", self, "_on_Node2D_won_battle")
	battle_scene.connect("lost_battle", self, "_on_Node2D_lost_battle")
	map_scene = MapScene.instance()
	add_child(start_scene)
	

func _on_Node2D_choose_starter(starter):
	player_party = [starter]
	remove_child(start_scene)
	add_child(map_scene)
