extends Enemy

var wave_mask: int = 0b100

func _physics_process(_delta):
	move_and_slide(velocity, Vector3.UP)


func _initialize(start_pos: Vector3, surf_speed: int):
	speed = 0			#hydrant doesn't move
	damage_value = 0	#doesn't deal damage
	health = 5			#dies in one shot
	
	var end_pos: Vector3 = start_pos
	end_pos.z -= 4.8	# face away from the wave
	
	look_at_from_position(start_pos, end_pos, Vector3.UP)
	
	velocity = Vector3.FORWARD * (speed - surf_speed)

# Enemy leaves the screen
func _on_VisibilityNotifier_screen_exited():
	queue_free()

func _get_damage_value() -> int:
	return damage_value

#When the hydrant is shot by a player bullet
func _take_damage(damage: int):
	#reduce health just in case
	health -= damage
	#set the hydrant to interact with the wave and not the player
	set_collision_mask(wave_mask)
	set_collision_layer(wave_mask)
	#The water spout heals the wave
	damage_value = -5
	#switch to the destroyed animation
	$Spatial/AnimatedSprite3D.set_animation("destroyed")
	#$Spatial/AnimatedSprite3D.set_playing(true)
	
		##play the destroyed sound effect


# When the enemy is destroyed
func _destroyed():
	#reset damage value
	damage_value = 0
	#don't let the hydrant collide anymore
	$CollisionShape.set_disabled(true)


func _calculate_speed():
	#Speed relative to the wave
	if health != 0:	#only if the enemy hasn't been destroyed
		velocity = Vector3.FORWARD * (speed - PlayerStats.get_surf_speed())

