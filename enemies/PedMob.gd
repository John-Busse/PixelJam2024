extends Enemy

export var ped_death_0: AudioStream
export var ped_death_1: AudioStream
var animation_index: int


func _physics_process(_delta):
	move_and_slide(velocity, Vector3.UP)


func _initialize(start_pos: Vector3, surf_speed: int):
	min_speed = 0.5
	max_speed = surf_speed / 2.0
	damage_value = 1
	health = 5
	
	var end_pos: Vector3 = start_pos
	end_pos.z -= 4.8	# face away from the wave
	
	look_at_from_position(start_pos, end_pos, Vector3.UP)
	speed = rand_range(min_speed, max_speed)	#the speed the mob is actually travelling
	
	velocity = Vector3.FORWARD * (speed - surf_speed)
	
	animation_index = randi() % 3
	$Spatial/AnimatedSprite3D.set_animation("human" + str(animation_index))
	$Spatial/AnimatedSprite3D.set_frame(randi() % 24)

# Enemy leaves the screen
func _on_VisibilityNotifier_screen_exited():
	queue_free()


func _get_damage_value() -> int:
	return damage_value

#When the enemy is shot by a player bullet
func _take_damage(damage: int):
	#reduce health
	health -= damage
	#Play damage audio
	$AudioStreamPlayer.play()
	#destroy the enemy if needed
	if health <= 0:
		_destroyed()

# When the enemy is destroyed (either by a bullet or the wave
func _destroyed():
	# health can only be <= 0 if shot by the player
	if health <= 0:
		#mark the enemy as destroyed
		PlayerStats.enemy_destroyed()
	health = 0
	
	damage_value = 0	#No longer deal damage
	velocity = Vector3.BACK * PlayerStats.get_surf_speed()	#stop moving
	$CollisionShape.set_disabled(true)
	$Spatial/AnimatedSprite3D.set_animation("dead" + str(animation_index))


func _calculate_speed():
	#Speed relative to the wave
	if health > 0.0:	#only if the enemy hasn't been destroyed
		velocity = Vector3.FORWARD * (speed - PlayerStats.get_surf_speed())

