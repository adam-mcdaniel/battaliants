extends Node2D


onready var fx_label = get_node("optionContainer/settingsContainer/Values/Fx_val")
onready var music_label = get_node("optionContainer/settingsContainer/Values/Music_val")
onready var text_speed_label = get_node("optionContainer/settingsContainer/Values/Text_val")
onready var sample_text = get_node("optionContainer/Sample_text")

onready var fx_slider = get_node("optionContainer/settingsContainer/Sliders/FxSlider")
onready var music_slider = get_node("optionContainer/settingsContainer/Sliders/MusicSlider")
onready var text_slider = get_node("optionContainer/settingsContainer/Sliders/HSlider")

var speed = 60
var visible_characters = 0

func _ready():
	load_settings()
	fx_label.text = str(fx_slider.value)
	music_label.text = str(music_slider.value)
	text_speed_label.text = str(text_slider.value)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if text_speed_label.text != "Instant":
		speed = int(text_speed_label.text)
		visible_characters += speed*delta
		sample_text.visible_characters = int(visible_characters)
		if sample_text.percent_visible >= 1:
			sample_text.visible_characters = 0
			visible_characters = 0
	else: 
		sample_text.percent_visible = 1

func load_settings():
	var config = ConfigFile.new()
	var err = config.load("settings.cfg")
	print(err)
	fx_slider.value = config.get_value("set", "fx", 100)
	music_slider.value = config.get_value("set", "music", 100)
	text_slider.value = config.get_value("set", "text_speed", 100)
	
func save_settings():
	var config = ConfigFile.new()
	config.set_value("set", "fx", fx_slider.value)
	config.set_value("set", "music", music_slider.value)
	config.set_value("set", "text_speed", text_slider.value)
	config.save("settings.cfg")
	
func _on_FxSlider_value_changed(value):
	fx_label.text = str(value)


func _on_MusicSlider_value_changed(value):
	music_label.text = str(value)


func _on_HSlider_value_changed(value):
	if value > 100:
		text_speed_label.text = "Instant"
	else:
		text_speed_label.text = str(value)


func _on_Button_pressed():
	save_settings()
	get_tree().change_scene("res://scenes/mainmenu/MainMenu.tscn")
