extends Node

## GLOBAL PLAYER VARIABLES
#weapon variables
var fire_rate: float = 0.5
var bullet_damage: int = 5
var bullet_speed: int = 5
#player variables
var health: float = 20.0
var max_health: float = 20.0
var move_speed: int = 5
var surf_speed: int = 4
var heal_rate: float = 0.5
#world variables
var tile_size: float = 4.8
var wave_height: int = 21
var enemies_defeated: int = 0
var bullets_fired: int = 0
var bullets_hit: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	#health is balance, this represents the player recovering their balance
	#if health is low, but not zero, restore it over time
	if health < max_health and health > 0.0:
		health += delta * heal_rate
	
	#clamp the health
	if health > max_health:
		health = max_health


func new_stage():
	#reset variables
	health = max_health
	bullets_fired = 0
	bullets_hit = 0
	enemies_defeated = 0
	surf_speed = 4


func take_damage(damage: int):
	health -= damage
	if health < 0.0:
		health = 0.0

# GETTERS
func get_bullet_damage() -> int:
	return bullet_damage


func get_bullet_speed() -> int:
	return bullet_speed


func get_surf_speed() -> int:
	return surf_speed


func get_wave_height() -> int:
	return wave_height


func get_move_speed() -> int:
	return move_speed


func get_fire_rate() -> float:
	return fire_rate


func get_health() -> int:
	return health as int


func get_max_health() -> int:
	return max_health as int


# SETTERS
func bullet_fired():
	bullets_fired += 1


func bullet_hit():
	bullets_hit += 1


func enemy_destroyed():
	enemies_defeated += 1


func set_surf_speed(new_speed: int):
	surf_speed = new_speed
