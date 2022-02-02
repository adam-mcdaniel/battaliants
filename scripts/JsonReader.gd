class_name JsonReader


var hp
var atk
var def
var spd
var stats
var rng = RandomNumberGenerator.new()

func init(ant_caste, ant_species):
	var data_file = File.new()
	data_file.open("res://data/AntStats.json", File.READ)
	var data_text = data_file.get_as_text()
	data_file.close()
	var data_parse = JSON.parse(data_text)
	var data = data_parse.result
	print(ant_species)
	stats = data[ant_caste][ant_species]
	rng.randomize()
#	print(generate_stats())
#	print(generate_crazy_stats())
	
	
func generate_stats():
#	hp = ( (60 * base_stat) + genetics * / 100) + 40
#	other = ( ( (2 * base_stat) + genetics) * 30) / 100) + 5
	hp = ((2 * stats["hp"] + rng.randi_range(0,50))*30/100)+40
	atk = (((2 * stats["atk"]) + rng.randi_range(0,50))*30/100)+5
	def = (((2 * stats["def"]) + rng.randi_range(0,50))*30/100)+5
	spd = (((2 * stats["spd"]) + rng.randi_range(0,50))*30/100)+5
	return [hp, atk, def, spd]
	
func generate_crazy_stats():
	hp = ((2 * rng.randi_range(stats["min_hp"], stats["max_hp"]) + rng.randi_range(0,50))*30/100)+40
	atk = (((2 * rng.randi_range(stats["min_atk"], stats["max_atk"])) + rng.randi_range(0,50))*30/100)+5
	def = (((2 * rng.randi_range(stats["min_def"], stats["max_def"])) + rng.randi_range(0,50))*30/100)+5
	spd = (((2 * rng.randi_range(stats["min_spd"], stats["max_spd"])) + rng.randi_range(0,50))*30/100)+5
	return [hp, atk, def, spd]
	
