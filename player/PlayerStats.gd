extends Node

## GLOBAL PLAYER VARIABLES
#weapon variables
var fire_rate: float = 0.5
var bullet_damage: int = 5
var bullet_speed: int = 2
#player variables
var health: float = 15.0
var max_health: float = 25.0
var move_speed: int = 2
var surf_speed: int = 4
var heal_rate: float = 0.5
#world variables
var wave_height: int = 25
var enemies_defeated: int = 0
var helis_defeated: int = 0
var bullets_fired: int = 0
var bullets_hit: int = 0
var currency: int = 0
#upgrade variables
var hydrant_timer: float = 3.0
var assistant_timer: float = 0.0
var enemy_timer: float = 6.0

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
	helis_defeated = 0
	surf_speed = 4


func take_damage(damage: int):
	health -= damage
	if health < 0.0:
		health = 0.0

# GETTERS
func get_fire_rate() -> float:
	return fire_rate

func get_bullet_damage() -> int:
	return bullet_damage

func get_bullet_speed() -> int:
	return bullet_speed

func get_health() -> int:
	return health as int

func get_max_health() -> int:
	return max_health as int

func get_move_speed() -> int:
	return move_speed

func get_surf_speed() -> int:
	return surf_speed

#func get_heal_rate

func get_wave_height() -> int:
	return wave_height

func get_enemies() -> int:
	return enemies_defeated

func get_helis() -> int:
	return helis_defeated

func get_bullets_fired() -> int:
	return bullets_fired

func get_bullets_hit() -> int:
	return bullets_hit

func get_accuracy() -> int:
	var accuracy: float = 0.0
	if bullets_fired > 0:
		accuracy = float(bullets_hit) / float(bullets_fired)
		accuracy *= 100

	return accuracy as int

func get_materials() -> int:
	return currency

func get_hydrant_timer() -> float:
	return hydrant_timer

# get assistant timer

func get_enemy_timer() -> float:
	return enemy_timer

# SETTERS
func bullet_fired():
	bullets_fired += 1


func bullet_hit():
	bullets_hit += 1


func enemy_destroyed():
	enemies_defeated += 1


func add_heli_destroyed():
	helis_defeated += 1


func set_surf_speed(new_speed: int):
	surf_speed = new_speed


func add_currency(extra: int):
	currency += extra


func get_upgrade(index: int) -> float:
	match index:
		0:	#Meteor size (wave height)
			return wave_height as float
		1:	#Fire Hydrant
			return hydrant_timer
		2:	#Assistant
			return assistant_timer
		3:	#Blaster Width (bullet_damage)
			return bullet_damage as float
		4:	#Blaster Length (bullet_speed)
			return bullet_speed as float
		5:	#Blaster Reciever (fire_rate)
			return fire_rate
		6:	#Surfboard Deck (max_health)
			return max_health
		7:	#Surfboard Fins (move_speed)
			return move_speed as float
		8:	#Surfboard Rails (heal_rate)
			return heal_rate
		9:	#Beach Ads (enemy_timer)
			return enemy_timer
	return -1.0

func buy_item(index: int, price: int):
	currency -= price
	match index:
		0:	#Meteor size (wave height)
			wave_height += 25
		1:	#Fire Hydrant
			hydrant_timer = 5.0
		2:	#Assistant
			assistant_timer = 5.0
		3:	#Blaster Width (bullet_damage)
			bullet_damage += 5
		4:	#Blaster Length (bullet_speed)
			bullet_speed += 2
		5:	#Blaster Reciever (fire_rate)
			fire_rate *= 0.5
		6:	#Surfboard Deck (max_health)
			max_health += 15
		7:	#Surfboard Fins (move_speed)
			move_speed += 2
		8:	#Surfboard Rails (heal_rate)
			heal_rate += 0.5
		9:	#beach ads (enemy_timer)
			enemy_timer -= 2.0
