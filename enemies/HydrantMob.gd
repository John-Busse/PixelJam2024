extends Enemy

export var wave_sound: AudioStream
var wave_mask: int = 0b100

func _physics_process(_delta):
# warning-ignore:return_value_discarded
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
	
	if health < 0:
		health = 0
	#set the hydrant to interact with the wave
	set_collision_mask(wave_mask)
	#The water spout heals the wave
	damage_value = -10
	#switch to the destroyed animation
	$Spatial/AnimatedSprite3D.set_animation("destroyed")
	#play the destroyed sound effect
	$AudioStreamPlayer.play()


# When the enemy is destroyed
func _destroyed():
	#reset damage value
	damage_value = 0
	#don't let the hydrant collide anymore
	$CollisionShape.set_disabled(true)
	#only play the noise if the hydrant was already destroyed
	if health == 0:
		$AudioStreamPlayer.set_stream(wave_sound)
		$AudioStreamPlayer.play()


func _calculate_speed():
	#Speed relative to the wave
	if health != 0:	#only if the enemy hasn't been destroyed
		velocity = Vector3.FORWARD * (speed - PlayerStats.get_surf_speed())

