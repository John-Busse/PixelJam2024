extends Enemy

signal can_fire
signal cant_fire
const THRESHOLD: float = 0.1
export var heli_explosion: AudioStream
export var heli_shot: AudioStream
export var heli_blades: PackedScene
var can_fire: bool = false
var alive: bool = true
var end_pos: Vector3
var player_node: Node

func _ready():
	pass

func _physics_process(_delta):
	var target_pos: Vector3 = (end_pos - translation).normalized()
	var player_pos: Vector3 = player_node.get_player_pos()
	player_pos.y = translation.y
	var direction = translation.x - player_pos.x
	
	if direction > 1.0 and alive:
		$Animations/AnimatedSprite3D.set_animation("heli_left")
	elif direction < -1.0 and alive:
		$Animations/AnimatedSprite3D.set_animation("heli_right")
	elif alive:
		$Animations/AnimatedSprite3D.set_animation("heli")
	
	#If we're not too close to our patrol point
	if translation.distance_to(end_pos) > THRESHOLD:
		velocity = target_pos * speed
		move_and_slide(velocity, Vector3.UP)
	else:
		if !can_fire:
			can_fire = true
			emit_signal("can_fire")
		flip_direction()
		

func init_heli(start_pos: Vector3, target_pos: Vector3, player: Node):
	end_pos = start_pos
	end_pos.z += 4.8
	player_node = player
	speed = 2.5
	damage_value = 0
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
	if health > 0:
		#play the wounded sound effect
		$AudioStreamPlayer.set_stream(heli_shot)
		$AudioStreamPlayer.play()
	else:
		_destroyed()

# When the enemy is destroyed (either by a bullet or the wave
func _destroyed():
	alive = false
	#Drop the helicopter under the wave
	global_translation.y -= 4.0
	
	# health can only be <= 0 if shot by the player
	if health <= 0:
		#mark the enemy as destroyed
		PlayerStats.add_heli_destroyed()
	
	health = 0
	damage_value = 0	#No longer deal damage
	speed = PlayerStats.get_surf_speed()			#No longer move
	end_pos = translation + Vector3(0.0, 0.0, 4.8)
	$CollisionShape.set_disabled(true)	#disable collision
	
	$Animations/AnimatedSprite3D.set_animation("destroyed")
	$Animations/explosionSprite.set_visible(true)
	$Animations/explosionSprite.play()
	
	$AudioStreamPlayer.set_stream(heli_explosion)
	$AudioStreamPlayer.play()
	emit_signal("cant_fire")
	
	var blades: Node = heli_blades.instance()
	add_child(blades)
	

#we recalculate speed when the game ends
func _calculate_speed():
	#Speed relative to the wave
	if health > 0:	#only if the enemy hasn't been destroyed
		#move the helicopter up and out
		end_pos = translation + Vector3(0.0, 0.0, -4.8)

func flip_direction():
	end_pos.x *= -1
