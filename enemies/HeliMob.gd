extends Enemy

signal can_fire
var can_fire: bool = false
var end_pos: Vector3
var player_node: Node
const THRESHOLD: float = 0.1

func _physics_process(_delta):
	var target_pos: Vector3 = (end_pos - translation).normalized()
	var player_pos: Vector3 = player_node.translation
	player_pos.y = translation.y
	look_at(player_pos, Vector3.UP)
	
	if translation.distance_to(end_pos) > THRESHOLD:
		velocity = target_pos * speed
		move_and_slide(velocity, Vector3.UP)
	else:
		if !can_fire:
			can_fire = true
			emit_signal("can_fire")
		flip_direction()


func _initialize(start_pos: Vector3, surf_speed: int):
	speed = 5
	damage_value = 20
	health = 50
	can_fire = false
	
	var end_pos: Vector3 = start_pos
	end_pos.z += 4.8	# face away from the wave
	
	speed = rand_range(min_speed, max_speed)	#the speed the mob is actually travelling
	
	velocity = Vector3.FORWARD * (speed - surf_speed)

func init_heli(start_pos: Vector3, target_pos: Vector3, player: Node):
	end_pos = start_pos
	end_pos.z -= 4.8
	player_node = player
	speed = 2.5
	damage_value = 20
	health = 50
	
	#look straight down
	look_at_from_position(start_pos, end_pos, Vector3.UP)
	end_pos = target_pos


func _get_damage_value() -> int:
	return damage_value

#When the enemy is shot by a player bullet
func _take_damage(damage: int):
	#reduce health
	health -= damage
		###play damage sound effect~~
	#destroy the enemy if needed
	if health <= 0:
		_destroyed()

# When the enemy is destroyed (either by a bullet or the wave
func _destroyed():
	global_translation.y -= 4.0
	
	# health can only be <= 0 if shot by the player
	if health <= 0:
		#mark the enemy as destroyed
		PlayerStats.enemy_destroyed()
	
	health = 0
	damage_value = 0	#No longer deal damage
	velocity = Vector3.BACK * PlayerStats.get_surf_speed()	#stop moving
	$CollisionShape.set_disabled(true)	#disable collision
	$Animations/AnimatedSprite3D.set_animation("destroyed")
	$Animations/explosionSprite.set_visible(true)


func _calculate_speed():
	#Speed relative to the wave
	if health > 0:	#only if the enemy hasn't been destroyed
		velocity = Vector3.FORWARD * (speed - PlayerStats.get_surf_speed())

func flip_direction():
	end_pos.x *= -1
