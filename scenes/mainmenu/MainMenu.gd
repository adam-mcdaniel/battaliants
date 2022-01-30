extends Node2D

func _on_PlayButton_pressed():
	get_tree().change_scene("res://scenes/Game.tscn")


func _on_OptionsButton_pressed():
	get_tree().change_scene("res://scenes/options/Options.tscn")


func _on_ExitButton_pressed():
	get_tree().quit()
