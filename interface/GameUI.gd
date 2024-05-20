extends Control

signal height_zero
signal spawn_heli
export var game_over_music: AudioStream
export var game_win_music: AudioStream
var distance_value: float = 0.0
var height_value: float
var height_drop_rate: float = 0.5
var speed: int
var heli_spawn_dist: float = 5000


func _ready():
	$GameGrid.set_visible(true)
	$GameOver.set_visible(false)
	$GameWon.set_visible(false)
	$EndgameStats.set_visible(false)
	$EndgameStats/EndRun.set_visible(false)


func _process(delta):
	#if the wave is above the ground and the game isn't over
	if height_value > 0.0 and !$EndgameStats.is_visible():
		var change: float = height_drop_rate * delta * -1.0
		set_height(change)
	
	if distance_value > heli_spawn_dist:
		heli_spawn_dist += 5000
		emit_signal("spawn_heli")


func init(height: int, health: int):
	height_value = height + 1
	distance_value = 0.0
	$GameGrid/HealthBar.set_max(health)
	$GameGrid/HealthBar.set_value(health)
	$GameGrid/HealthBar.set_custom_minimum_size(Vector2(health, 5))


func set_speed(new_speed: int):
	speed = new_speed


func set_height(change: float):
	height_value += change
	
	if height_value <= 0.0:
		height_value = 0.0
		emit_signal("height_zero")
	
	var height: String = String(height_value as int)
	
	$GameGrid/HeightValue.set_text(str(height + " m"))

func set_health(health: int):
	$GameGrid/HealthBar.set_value(health)

#Set the distance, based on distance from the tile origin
func set_dist(origin: float):
	distance_value = origin * 100.0 / 4.8
	
	var dist: String = String(distance_value as int)
	
	$GameGrid/DistValue.set_text(str(dist + " m"))


func get_height() -> float :
	return height_value


func game_over():
	Global.change_song(game_over_music)
	$GameOver.set_visible(true)	#enable game over
	end_game()
	pass


func game_win():
	Global.change_song(game_win_music)
	$GameWon.set_visible(true)	#enable game won
	end_game()
	pass


func end_game():
	$EndgameStats.set_visible(true)
	$EndgameStats/EndgameTimer.start()
	#Display the various stats
	var text: String
#	text = "Shots fired: " + str(PlayerStats.get_bullets_fired())
#	$EndgameStats/EndgamePanel/VBoxContainer/ShotsFiredLabel.set_text(text)
#	text = "Shots hit: " + str(PlayerStats.get_bullets_hit())
#	$EndgameStats/EndgamePanel/VBoxContainer/ShotsHitLabel.set_text(text)
#	text = "Accuracy: " + str(PlayerStats.get_accuracy()) + " %"
#	$EndgameStats/EndgamePanel/VBoxContainer/AccuracyLabel.set_text(text)
	text = "Enemies Defeated " + str(PlayerStats.get_enemies())
	$EndgameStats/EndgamePanel/VBoxContainer/EnemiesLabel.set_text(text)
	text = "Reward: " + str(PlayerStats.get_enemies() * 5) + " materials"
	$EndgameStats/EndgamePanel/VBoxContainer/EnemyReward.set_text(text)
	var new_currency: int = PlayerStats.get_enemies() * 5
	text = "Distance Traveled " + str(distance_value as int) + " m"
	$EndgameStats/EndgamePanel/VBoxContainer/DistanceLabel.set_text(text)
	text = "Reward: " + str((distance_value / 100) as int) + " materials"
	$EndgameStats/EndgamePanel/VBoxContainer/RewardLabel.set_text(text)
	new_currency += distance_value / 100
	
	if PlayerStats.get_helis() > 0:
		$EndgameStats/EndgamePanel/VBoxContainer/HeliLabel.set_visible(true)
		$EndgameStats/EndgamePanel/VBoxContainer/HeliReward.set_visible(true)
		text = "Choppers Destroyed: " + str(PlayerStats.get_helis())
		$EndgameStats/EndgamePanel/VBoxContainer/HeliLabel.set_text(text)
		text = "Reward: " + str(PlayerStats.get_helis() * 500) + " materials"
		$EndgameStats/EndgamePanel/VBoxContainer/HeliReward.set_text(text)
		new_currency += PlayerStats.get_helis() * 500
	
	if $GameOver.visible:
		#If this is a game over
		$EndgameStats/EndgamePanel/VBoxContainer/PenaltyLabel.set_visible(true)
		new_currency *= 0.5
	else:
		$EndgameStats/EndgamePanel/VBoxContainer/PenaltyLabel.set_visible(false)
	text = "Total Materials gained: " + str(new_currency)
	PlayerStats.add_currency(new_currency)
	$EndgameStats/EndgamePanel/VBoxContainer/CurrencyLabel.set_text(text)
	$EndgameStats/EndgamePanel/VBoxContainer/CurrencyLabel.set_visible(true)
	$EndgameStats/EndgamePanel.set_anchors_preset(Control.PRESET_CENTER, true)


func endgame_timer():
	$EndgameStats/EndRun.set_visible(true)


func exit_level():
	if $EndgameStats/EndRun.is_visible():
		Global.goto_scene("res://interface/UpgradeMenu.tscn")
