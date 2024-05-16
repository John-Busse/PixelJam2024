extends Control


func start_game():
	Global.goto_scene("res://levels/Stage.tscn")


func credits_menu():
	Global.goto_scene("res://interface/Credits.tscn")


func controls_menu():
	Global.goto_scene("res://interface/Controls.tscn")
