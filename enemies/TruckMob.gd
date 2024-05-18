extends Enemy


export var wheel_scene: PackedScene

func _physics_process(_delta):
	move_and_slide(velocity, Vector3.UP)


func _initialize(start_pos: Vector3, surf_speed: int):
	min_speed = surf_speed - 1.5
	max_speed = surf_speed - 0.5 #max speed needs to be less than the surf_speed
	damage_value = 10
	health = 15
	
	var end_pos: Vector3 = start_pos
	end_pos.z -= 4.8	# face away from the wave
	
	look_at_from_position(start_pos, end_pos, Vector3.UP)
	speed = rand_range(min_speed, max_speed)	#the speed the mob is actually travelling
	
	velocity = Vector3.FORWARD * (speed - surf_speed)

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
	$CollisionShape.set_disabled(true)
	# health can only be <= 0 if shot by the player
	if health <= 0:
		#mark the enemy as destroyed
		PlayerStats.enemy_destroyed()
	
	health = 0
	damage_value = 0	#No longer deal damage
	velocity = Vector3.BACK * PlayerStats.get_surf_speed()	#stop moving
	$Spatial/AnimatedSprite3D.set_animation("destroyed")
	$Spatial/explosionSprite.set_visible(true)
	$Spatial/explosionSprite.play()
	
	var num_wheels = randi() % 5
	
	if num_wheels > 0:
		for i in range(1,num_wheels):
			var mob: Node = wheel_scene.instance()
			add_child(mob)


func _calculate_speed():
	#Speed relative to the wave
	if health > 0:	#only if the enemy hasn't been destroyed
		velocity = Vector3.FORWARD * (speed - PlayerStats.get_surf_speed())
