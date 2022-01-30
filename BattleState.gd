class_name BattleState

var player_party = null
var enemy_party  = null

var is_player_turn = true

var nth_player_ant = null
var player_ant = null
var nth_enemy_ant = null
var enemy_ant  = null

var all_enemies_dead = false
var all_players_dead = false

func get_player_party():
	return player_party
	
func get_enemy_party():
	return enemy_party

func update():
	var i = 0
	if player_party != null:
		for ant in player_party:
			if ant.is_dead():
				player_party.remove(i)
				if nth_player_ant > i:
					nth_player_ant -= 1
			i += 1
	i = 0
	
	if enemy_party != null:
		for ant in enemy_party:
			if ant.is_dead():
				enemy_party.remove(i)
				if nth_enemy_ant > i:
					nth_enemy_ant -= 1
			i += 1
	
# Call this on your turn to swap your currently
# active ant with the `nth` one in your party.
func swap_in(n):
	assert(n < len(player_party))
	if is_player_turn:
		player_ant = player_party[n]
		nth_player_ant = n
	else:
		enemy_ant = enemy_party[n]
		nth_enemy_ant = n

func start_battle(pp, ep):
	player_party = pp
	for ant in player_party:
		ant.reset_moves()
	
	enemy_party = ep
	for ant in enemy_party:
		ant.reset_moves()
	
	player_ant = player_party[0]
	enemy_ant = enemy_party[0]
	nth_player_ant = 0
	nth_enemy_ant = 0

	is_player_turn = player_ant.get_speed() >= enemy_ant.get_speed()

func end_turn():
	is_player_turn = not is_player_turn

func get_current_ant():
	return player_ant if is_player_turn else enemy_ant
	
func has_player_lost():
	for ant in player_party:
		if ant.is_alive():
			return false
	return true

func has_player_won():
	return is_over() and not has_player_lost()
	
func has_enemy_lost():
	for ant in enemy_party:
		if ant.is_alive():
			return false
	return true
	
func has_enemy_won():
	return is_over() and not has_player_lost()

func is_over():
	var player_ant_alive = false
	for ant in player_party:
		player_ant_alive = player_ant_alive or ant.is_alive()
	if not player_ant_alive: all_players_dead = true
	
	var enemy_ant_alive = false
	for ant in enemy_party:
		enemy_ant_alive = enemy_ant_alive or ant.is_alive()
	if not enemy_ant_alive: all_enemies_dead = true
	
	return (not player_ant_alive) or (not enemy_ant_alive)


var rng = RandomNumberGenerator.new()
func _ready():
	rng.randomize()

func take_player_turn_enemy(n):
	if not is_player_turn or player_ant.is_dead():
		return
	var moves = player_ant.get_moves()
	var move = moves[n]
	
	move.perform(self,
		player_ant,
		enemy_ant,
		enemy_ant)
	
	moves[n] = move
	player_ant.set_moves(moves)
	player_party[nth_player_ant] = player_ant
	enemy_party[nth_enemy_ant] = enemy_ant
	
	if player_ant.is_dead():
		var i = 0
		for ant in player_party:
			if ant.is_alive():
				swap_in(i)
			i += 1
			
	end_turn()
	
func take_player_turn_self(n):
	if not is_player_turn or player_ant.is_dead():
		return
	var moves = player_ant.get_moves()
	var move = moves[n]
	
	move.perform(self,
		player_ant,
		player_ant,
		enemy_ant)
		
	moves[n] = move
	player_ant.set_moves(moves)
	player_party[nth_player_ant] = player_ant
	enemy_party[nth_enemy_ant] = enemy_ant
	
	if player_ant.is_dead():
		var i = 0
		for ant in player_party:
			if ant.is_alive():
				swap_in(i)
			i += 1
			
	end_turn()

func take_enemy_turn():
	if is_player_turn:
		return
	if enemy_ant.is_dead():
		var i = 0
		for ant in enemy_party:
			if ant.is_alive():
				swap_in(i)
			i += 1
		end_turn()
	else:
		var ant = get_current_ant()
		var moves = ant.get_moves()
		var move = moves[rng.randi_range(0, len(moves)-1)]
		
		while not move.can_perform():
			move = moves[rng.randi_range(0, len(moves)-1)]
		
		move.perform(self,
			ant,
			enemy_ant if move.is_benevolent() else player_ant,
			player_ant)
		
		ant.set_moves(moves)
		enemy_party[nth_enemy_ant] = enemy_ant
		player_party[nth_player_ant] = player_ant
		end_turn()
