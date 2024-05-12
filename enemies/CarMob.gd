extends Enemy


func _physics_process(delta):
	move_and_slide(velocity, Vector3.UP)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _initialize(start_pos: Vector3, end_pos: Vector3):
	min_speed = 1.5
	max_speed = 4.0
	
	#Face toward the wave first to get the direction of movement
	end_pos.z += 4.8	#face toward the wave
	
	look_at_from_position(start_pos, end_pos, Vector3.UP)
	var rand_speed: float = rand_range(min_speed, max_speed)
	
	velocity = Vector3.FORWARD * rand_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	
	end_pos.z -= 9.6	#face away from the wave for the illusion of motion
	look_at_from_position(start_pos, end_pos, Vector3.UP)


func _on_VisibilityNotifier_screen_exited():
	queue_free()
