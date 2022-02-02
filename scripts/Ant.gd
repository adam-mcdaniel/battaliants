class_name Ant

var statscript = preload("res://scripts/JsonReader.gd").new()

enum Species {
	CRAZY,
	LEAFCUTTER,
	BULLET,
	FIRE
}


enum Caste {
	WORKER,
	BUFF,
	LARVAE,
	CANT,
	NEOPHYTE,
	QUEEN
}

var speed = 1
var attack = 1
var defense = 1
var current_hp = 3
var max_hp = 3
var species = Species.LEAFCUTTER
var caste = Caste.WORKER

const Bite = preload("res://scripts/moves/Bite.gd")
const Feed = preload("res://scripts/moves/Feed.gd")

func get_animation_name():
	var name = ""
	match get_species():
		Species.CRAZY:
			name += "crazy_"
		Species.LEAFCUTTER:
			name += "leaf_"
		Species.BULLET:
			name += "bullet_"
		Species.FIRE:
			name += "red_"
			
	match get_caste():
		Caste.WORKER:
			name += "worker"
		Caste.BUFF:
			name += "buff"
		Caste.LARVAE:
			name += "larvae"
		Caste.CANT:
			name += "cant"
		Caste.NEOPHYTE:
			name += "neophyte"
		Caste.QUEEN:
			name += "queen"
	return name

func get_json_name():
	var species
	var caste
	match get_species():
		Species.CRAZY:
			species = "Crazyant"
		Species.LEAFCUTTER:
			species = "Leafcutter Ant"
		Species.BULLET:
			species = "Bulletant"
		Species.FIRE:
			species = "Fireant"
			
	match get_caste():
		Caste.WORKER:
			caste = "Worker"
		Caste.BUFF:
			caste =  "Buff"
		Caste.LARVAE:
			caste = "Larvae"
		Caste.CANT:
			caste = "Cant"
		Caste.NEOPHYTE:
			caste = "Neophyte"
		Caste.QUEEN:
			caste = "Queen"
	return [species, caste]

func set_stats():
	var jsonname = get_json_name()
	var statslist
	statscript.init(jsonname[1], jsonname[0])
	if jsonname[0] == "Crazyant":
		statslist =  statscript.generate_crazy_stats()
	else:
		statslist = statscript.generate_stats()
	
	current_hp = statslist[0]
	max_hp = statslist[0]
	attack = statslist[1]
	defense = statslist[2]
	speed = statslist[3]
	
		
func get_moves():
	return [Bite.new(), Feed.new()]
	
func set_moves(moves):
	pass

func reset_moves():
	for move in get_moves():
		move.reset()

func get_species():
	return species

func get_caste():
	return caste

func get_name():
	return ""


func get_speed():
	return speed

func get_attack():
	return attack
	
func get_defense():
	return defense
	
func get_current_hp():
	return current_hp
	
func get_max_hp():
	return max_hp



func is_dead():
	return current_hp <= 0 || max_hp <= 0

func is_alive():
	return not is_dead()

func kill():
	current_hp = 0



func take_damage(damage):
	current_hp -= damage
	print("ow! %s has %d hp left" % [get_name(), get_current_hp()])
	
func heal_hp(health):
	print("thanks!")
	current_hp = min(current_hp + health, max_hp)


func increase_speed(n):
	speed += n
	
func decrease_speed(n):
	speed -= n


func increase_defense(n):
	defense += n

func decrease_defense(n):
	defense -= n


func increase_attack(n):
	attack += n

func decrease_attack(n):
	attack -= n


func increase_max_hp(n):
	max_hp += n

func decrease_max_hp(n):
	max_hp -= n
