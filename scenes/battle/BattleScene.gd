extends Node2D
var battle_state = null
var selected_target = null
var selected_move = null

var BattleState = load("res://BattleState.gd")
const Ant = preload("res://scripts/Ant.gd")
const Larvae = preload("res://scripts/Larvae.gd")
const Worker = preload("res://scripts/Worker.gd")
const Queen = preload("res://scripts/Queen.gd")

const HUD = preload("res://scenes/battle/HUD.tscn")
var player_hud = HUD.instance()
var enemy_hud = HUD.instance()

onready var bgm = $AudioStreamPlayer
var volume = 100
var sfx = 100

signal won_battle(modified_player_party, last_enemy_ant)
signal lost_battle()

# Called when the node enters the scene tree for the first time.
func _ready():
	load_settings()
	bgm.volume_db = volume
	player_hud.position.x = 110
	player_hud.position.y = 330
	
	enemy_hud.position.x = 740
	enemy_hud.position.y = 190
	add_child(player_hud)
	add_child(enemy_hud)
	
	clear_buttons()
	
	player_hud.setup(battle_state.player_ant)
	enemy_hud.setup(battle_state.enemy_ant, true)
	
	if battle_state.is_player_turn:
		setup_buttons()

func start_battle(player_party, enemy_party):
	battle_state = BattleState.new()
	battle_state.start_battle(player_party, enemy_party)

func _process(delta):
	if battle_state == null: return
	if battle_state.is_over() and battle_state.all_enemies_dead:
		emit_signal("won_battle", battle_state.player_party, battle_state.enemy_ant)
		print("won")
	elif battle_state.is_over() and battle_state.all_players_dead:
		emit_signal("lost_battle")
		print("lost")

	player_hud.setup(battle_state.player_ant)
	enemy_hud.setup(battle_state.enemy_ant)
	
	battle_state.update()
	
	if battle_state.is_over():
		clear_buttons()
	elif not battle_state.is_player_turn:
		clear_buttons()
		battle_state.take_enemy_turn()
		setup_buttons()

func get_move(n):
	return battle_state.get_current_ant().get_moves()[n]
	
func get_num_moves():
	return len(battle_state.get_current_ant().get_moves())

func setup_buttons():
	selected_move = null
	selected_target = null
	clear_buttons()
	if get_num_moves() > 0:
		$GridContainer/Button1.text = get_move(0).get_name()
		$GridContainer/Button1.connect("pressed", self, "choose_move1")
		$GridContainer/Button1.disabled = not get_move(0).can_perform()
	else:
		$GridContainer/Button1.disabled = true
		
	if get_num_moves() > 1:
		$GridContainer/Button2.text = get_move(1).get_name()
		$GridContainer/Button2.connect("pressed", self, "choose_move2")
		$GridContainer/Button2.disabled = not get_move(1).can_perform()
	else:
		$GridContainer/Button2.disabled = true
		
		
	if get_num_moves() > 2:
		$GridContainer/Button3.text = get_move(2).get_name()
		$GridContainer/Button3.connect("pressed", self, "choose_move3")
		$GridContainer/Button3.disabled = not get_move(2).can_perform()
	else:
		$GridContainer/Button3.disabled = true
	
	if get_num_moves() > 3:
		$GridContainer/Button4.text = get_move(3).get_name()
		$GridContainer/Button4.connect("pressed", self, "choose_move4")
		$GridContainer/Button4.disabled = not get_move(3).can_perform()
	else:
		$GridContainer/Button4.disabled = true
	
	$GridContainer/Button5.text = "Runaway"
	$GridContainer/Button5.connect("pressed", self, "runaway")
	
	$GridContainer/Button6.text = "Swap Out"
	$GridContainer/Button6.connect("pressed", self, "swap")

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

func do_nothing(): pass

func clear_buttons():
	$GridContainer/Button1.text = ""
	$GridContainer/Button1.disconnect("pressed", self, "choose_enemy")
	$GridContainer/Button1.disconnect("pressed", self, "choose_move1")
	$GridContainer/Button1.disconnect("pressed", self, "swap1")
	$GridContainer/Button1.disabled = false
	
	$GridContainer/Button2.text = ""
	$GridContainer/Button2.disconnect("pressed", self, "choose_self")
	$GridContainer/Button2.disconnect("pressed", self, "choose_move2")
	$GridContainer/Button2.disconnect("pressed", self, "swap2")
	$GridContainer/Button2.disabled = false
	
	$GridContainer/Button3.text = ""
	$GridContainer/Button3.disconnect("pressed", self, "choose_move3")
	$GridContainer/Button3.disconnect("pressed", self, "swap3")
	$GridContainer/Button3.disabled = false
	
	$GridContainer/Button4.text = ""
	$GridContainer/Button4.disconnect("pressed", self, "choose_move4")
	$GridContainer/Button4.disconnect("pressed", self, "swap4")
	$GridContainer/Button4.disabled = false
	
	$GridContainer/Button5.text = ""
	$GridContainer/Button5.disconnect("pressed", self, "runaway")
	$GridContainer/Button5.disconnect("pressed", self, "swap5")
	$GridContainer/Button5.disabled = false
	
	$GridContainer/Button6.text = ""
	$GridContainer/Button6.disconnect("pressed", self, "swap")
	$GridContainer/Button6.disconnect("pressed", self, "swap6")
	$GridContainer/Button6.disabled = false

func choose_target():
	clear_buttons()
	$GridContainer/Button1.text = battle_state.enemy_ant.get_name()
	$GridContainer/Button1.connect("pressed", self, "choose_enemy")
	
	$GridContainer/Button2.text = "Self"
	$GridContainer/Button2.connect("pressed", self, "choose_self")
	
func swap():
	clear_buttons()
	var player_party = battle_state.get_player_party()
	if len(player_party) > 0:
		$GridContainer/Button1.text = player_party[0].get_name()
		$GridContainer/Button1.connect("pressed", self, "swap1")
	else:
		$GridContainer/Button1.disabled = true
		
	if len(player_party) > 1:
		$GridContainer/Button2.text = player_party[1].get_name()
		$GridContainer/Button2.connect("pressed", self, "swap2")
	else:
		$GridContainer/Button2.disabled = true
		
	if len(player_party) > 2:
		$GridContainer/Button3.text = player_party[2].get_name()
		$GridContainer/Button3.connect("pressed", self, "swap3")
	else:
		$GridContainer/Button3.disabled = true
		
	if len(player_party) > 3:
		$GridContainer/Button4.text = player_party[3].get_name()
		$GridContainer/Button4.connect("pressed", self, "swap4")
	else:
		$GridContainer/Button4.disabled = true
		
	if len(player_party) > 4:
		$GridContainer/Button5.text = player_party[4].get_name()
		$GridContainer/Button5.connect("pressed", self, "swap5")
	else:
		$GridContainer/Button5.disabled = true
		
	if len(player_party) > 5:
		$GridContainer/Button6.text = player_party[5].get_name()
		$GridContainer/Button6.connect("pressed", self, "swap6")
	else:
		$GridContainer/Button6.disabled = true

func swap1():
	battle_state.swap_in(0)
	battle_state.end_turn()
	if battle_state.is_player_turn:
		setup_buttons()
	else:
		clear_buttons()
	
func swap2():
	battle_state.swap_in(1)
	battle_state.end_turn()
	if battle_state.is_player_turn:
		setup_buttons()
	else:
		clear_buttons()
		
func swap3():
	battle_state.swap_in(2)
	battle_state.end_turn()
	if battle_state.is_player_turn:
		setup_buttons()
	else:
		clear_buttons()
	
func swap4():
	battle_state.swap_in(3)
	battle_state.end_turn()
	if battle_state.is_player_turn:
		setup_buttons()
	else:
		clear_buttons()
	
func swap5():
	battle_state.swap_in(4)
	battle_state.end_turn()
	if battle_state.is_player_turn:
		setup_buttons()
	else:
		clear_buttons()
	
func swap6():
	battle_state.swap_in(5)
	battle_state.end_turn()
	if battle_state.is_player_turn:
		setup_buttons()
	else:
		clear_buttons()
	

func choose_enemy():
	selected_target = battle_state.enemy_ant
	battle_state.take_player_turn_enemy(selected_move)
	if battle_state.is_player_turn:
		setup_buttons()
	else:
		clear_buttons()
		
	
func choose_self():
	selected_target = battle_state.player_ant
	battle_state.take_player_turn_self(selected_move)
	if battle_state.is_player_turn:
		setup_buttons()
	else:
		clear_buttons()

func choose_move1():
	clear_buttons()
	selected_move = 0
	assert(get_num_moves() > selected_move)
	if get_move(selected_move).uses_target():
		choose_target()
	else:
		selected_target = null
		battle_state.take_player_turn_enemy(selected_move)
		if battle_state.is_player_turn:
			setup_buttons()
		else:
			clear_buttons()
	
func choose_move2():
	clear_buttons()
	selected_move = 1
	assert(get_num_moves() > selected_move)
	if get_move(selected_move).uses_target():
		choose_target()
	else:
		selected_target = null
		battle_state.take_player_turn_enemy(selected_move)
		if battle_state.is_player_turn:
			setup_buttons()
		else:
			clear_buttons()
	
	
func choose_move3():
	clear_buttons()
	selected_move = 2
	assert(get_num_moves() > selected_move)
	if get_move(selected_move).uses_target():
		choose_target()
	else:
		selected_target = null
		battle_state.take_player_turn_enemy(selected_move)
		if battle_state.is_player_turn:
			setup_buttons()
		else:
			clear_buttons()
	
func choose_move4():
	clear_buttons()
	selected_move = 3
	assert(get_num_moves() > selected_move)
	if get_move(selected_move).uses_target():
		choose_target()
	else:
		selected_target = null
		battle_state.take_player_turn_enemy(selected_move)
		if battle_state.is_player_turn:
			setup_buttons()
		else:
			clear_buttons()
