extends Enemy


func init(spawn_loc: Vector3, player_loc: Vector3):
	player_loc.y = spawn_loc.y
	damage_value = 15
	look_at_from_position(spawn_loc, player_loc, Vector3.UP)
	# and its velocity
	velocity = Vector3.FORWARD * 4.0
	velocity = velocity.rotated(Vector3.UP, rotation.y)


func _physics_process(_delta):
	move_and_slide(velocity, Vector3.UP)

func _on_VisibilityNotifier_screen_exited():
	#despawn the bullet when it leaves the screen
	queue_free()

func _destroyed():
	queue_free()
