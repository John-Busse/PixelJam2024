extends Control


export var menu_theme: AudioStream

func _ready():
	Global.change_song(menu_theme)
	$AnimatedSprite.play()


func start_game():
	Global.goto_scene("res://levels/Stage.tscn")


func credits_menu():
	Global.goto_scene("res://interface/Credits.tscn")


func controls_menu():
	Global.goto_scene("res://interface/Controls.tscn")


func load_game():
	if Global.load_game():
		Global.goto_scene("res://interface/UpgradeMenu.tscn")
	else:
		print("File not found")
		$MessageContainer.set_visible(true)
		$MessageTimer.start()

#hide the message container
func _on_MessageTimer_timeout():
	$MessageContainer.set_visible(false)
