extends Node

## GLOBAL PLAYER VARIABLES
#weapon variables
var fire_rate: float = 0.6
var bullet_damage: int = 5
var bullet_speed: int = 2
#player variables
var health: float = 25.0
var max_health: float = 25.0
var move_speed: int = 2
var surf_speed: int = 3
var heal_rate: float = 0.5
#world variables
var wave_height: int = 25
var enemies_defeated: int = 0
var helis_defeated: int = 0
var bullets_fired: int = 0
var bullets_hit: int = 0
var currency: int = 0
#upgrade variables
var hydrant_timer: float = 0.0
var enemy_timer: float = 6.0


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
	surf_speed = 3


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

func get_heal_rate() -> float:
	return heal_rate

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

func get_enemy_timer() -> float:
	return enemy_timer

# SETTERS
func bullet_fired():
	bullets_fired += 1


func bullet_hit():
	bullets_hit += 1


func enemy_destroyed(enemy: int = 1):
	enemies_defeated += enemy


func add_heli_destroyed():
	helis_defeated += 1


func set_surf_speed(new_speed: int):
	surf_speed = new_speed


func add_currency(extra: int):
	currency += extra


func get_upgrade(index: int) -> float:
	index -= 3
	match index:
		0:	#Surfboard Fins (move_speed)
			return move_speed as float
		1:	#Surfboard Deck (max_health)
			return max_health
		2:	#Surfboard Rails (heal_rate)
			return heal_rate
		3:	#Blaster Width (bullet_damage)
			return bullet_damage as float
		4:	#Blaster Length (bullet_speed)
			return bullet_speed as float
		5:	#Blaster Reciever (fire_rate)
			return fire_rate
		6:	#Meteor size (wave height)
			return wave_height as float
		7:	#Fire Hydrant
			return hydrant_timer
		8:	#Beach Ads (enemy_timer)
			return enemy_timer
	return -1.0

func buy_item(index: int, price: int):
	index -= 3
	currency -= price
	match index:
		0:	#Surfboard Fins (move_speed)
			move_speed += 2
		1:	#Surfboard Deck (max_health)
			max_health += 15
		2:	#Surfboard Rails (heal_rate)
			heal_rate += 0.5
		3:	#Blaster Width (bullet_damage)
			bullet_damage += 5
		4:	#Blaster Length (bullet_speed)
			bullet_speed += 2
		5:	#Blaster Reciever (fire_rate)
			fire_rate -= 0.3
		6:	#Meteor size (wave height)
			wave_height += 25
		7:	#Fire Hydrant
			if hydrant_timer == 0.0:
				hydrant_timer = 12.8
			else:
				hydrant_timer = 6.4
		8:	#beach ads (enemy_timer)
			enemy_timer -= 2.0


func save_game() -> Dictionary:
	var save_dict: Dictionary = {
		"fire_rate" : fire_rate,
		"bullet_damage" : bullet_damage,
		"bullet_speed" : bullet_speed,
		"max_health" : max_health,
		"move_speed" : move_speed,
		"heal_rate" : heal_rate,
		"wave_height" : wave_height,
		"materials" : currency,
		"hydrant_timer" : hydrant_timer,
		"enemy_timer" : enemy_timer
	}
	return save_dict


func load_game(save_data: Dictionary):
		fire_rate = save_data["fire_rate"]
		bullet_damage = save_data["bullet_damage"]
		bullet_speed = save_data["bullet_speed"]
		max_health = save_data["max_health"]
		move_speed = save_data["move_speed"]
		heal_rate = save_data["heal_rate"]
		wave_height = save_data["wave_height"]
		currency = save_data["materials"]
		hydrant_timer = save_data["hydrant_timer"]
		enemy_timer = save_data["enemy_timer"]

#Reset all the standard player variables
func reset_game():
	fire_rate = 0.5
	bullet_damage = 5
	bullet_speed = 2
	max_health = 25.0
	move_speed = 2
	heal_rate = 0.5
	wave_height = 25
	currency = 0
	hydrant_timer = 0.0
	enemy_timer = 6.0
