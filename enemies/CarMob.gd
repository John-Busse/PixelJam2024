extends Enemy


func _physics_process(_delta):
	move_and_slide(velocity, Vector3.UP)


func _initialize(start_pos: Vector3, end_pos: Vector3):
	min_speed = 1.5
	max_speed = 4.0
	damage_value = 5
	health = 10
	
	#Face toward the wave first to get the direction of movement
	end_pos.z += 4.8	#face toward the wave
	
	look_at_from_position(start_pos, end_pos, Vector3.UP)
	speed = rand_range(min_speed, max_speed)
	
	velocity = Vector3.FORWARD * speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	
	end_pos.z -= 9.6	#face away from the wave for the illusion of motion
	look_at_from_position(start_pos, end_pos, Vector3.UP)

# Enemy leaves the screen
func _on_VisibilityNotifier_screen_exited():
	queue_free()


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
	var player_stats = get_node("/root/PlayerStats")
	# health can only be <= 0 if shot by the player
	if health <= 0:
		#mark the enemy as destroyed
		player_stats.enemy_destroyed()
	
	damage_value = 0	#No longer deal damage
	velocity = Vector3.BACK * player_stats.get_surf_speed()	#stop moving
	$CollisionShape.set_disabled(true)
	$Spatial/AnimatedSprite3D.set_animation("destroyed")
