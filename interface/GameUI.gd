extends Control

signal height_zero
var distance_value: float = 0.0
var height_value: float
var height_drop_rate: float = 0.5
var speed: int


func _ready():
	$GameGrid.set_visible(true)
	$GameOver.set_visible(false)
	$GameWon.set_visible(false)
	$EndgameStats.set_visible(false)


func _process(delta):	
	if height_value > 0.0:
		var change: float = height_drop_rate * delta * -1.0
		set_height(change)


func init(height: int, health: int):
	height_value = height
	distance_value = 0.0
	$GameGrid/HealthBar.set_max(health)
	$GameGrid/HealthBar.set_value(health)
	$GameGrid/HealthBar.set_custom_minimum_size(Vector2(health * 2, 10))


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
	end_game()
	$GameOver.set_visible(true)	#enable game over
	pass


func game_win():
	end_game()
	$GameWon.set_visible(true)	#enable game won
	pass


func end_game():
	$EndgameStats.set_visible(true)
	#Display the various stats
	var text: String
	text = "Shots fired: " + str(PlayerStats.get_bullets_fired())
	$EndgameStats/PanelContainer/VBoxContainer/ShotsFiredLabel.set_text(text)
	text = "Shots hit: " + str(PlayerStats.get_bullets_hit())
	$EndgameStats/PanelContainer/VBoxContainer/ShotsHitLabel.set_text(text)
	text = "Accuracy: " + str(PlayerStats.get_accuracy()) + " %"
	$EndgameStats/PanelContainer/VBoxContainer/AccuracyLabel.set_text(text)
	text = "Enemies Defeated " + str(PlayerStats.get_enemies())
	$EndgameStats/PanelContainer/VBoxContainer/EnemiesLabel.set_text(text)
	var new_currency: int = distance_value / 100 + PlayerStats.get_enemies() * 5
	text = "Materials gained: " + str(new_currency)
	PlayerStats.add_currency(new_currency)
	$EndgameStats/PanelContainer/VBoxContainer/CurrencyLabel.set_text(text)
