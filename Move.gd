class_name Move
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rng = RandomNumberGenerator.new()

func perform(battle_state, caster, target=null, opposing_ant=null):
	pass

func can_perform():
	return true

func is_benevolent():
	return false
	
func uses_target():
	return true
	
func reset():
	pass

func get_name():
	return ""

func damage_calc(power, atk, def):
	var crit = 1
	rng.randomize()
	if rng.randi_range(0,8) == 4:
		crit = 1.5
	return round((14*power*(atk/def)/50)*crit)
