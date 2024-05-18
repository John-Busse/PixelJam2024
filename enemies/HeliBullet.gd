extends Enemy


func _physics_process(_delta):
	velocity = move_and_slide(velocity, Vector3.UP)


func init(spawn_loc: Vector3, player_loc: Vector3):
	damage_value = 20
	look_at_from_position(spawn_loc, player_loc, Vector3.UP)
	# and its velocity
	velocity = Vector3.FORWARD * 5.0
	velocity = velocity.rotated(Vector3.UP, rotation.y)


func _on_VisibilityNotifier_screen_exited():
	#despawn the bullet when it leaves the screen
	queue_free()
