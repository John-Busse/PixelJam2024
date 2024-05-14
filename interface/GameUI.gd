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
	origin *= 100.0 / 4.8
	
	var dist: String = String(origin as int)
	
	$GameGrid/DistValue.set_text(str(dist + " m"))


func get_height() -> float :
	return height_value


func game_over():
	#$GameGrid.set_visible(false)	#disable the game UI
	$GameOver.set_visible(true)	#enable game over
	pass


func game_win():
	#$GameGrid.set_visible(false)	#disable game UI
	$GameWon.set_visible(true)	#enable game won
	pass
