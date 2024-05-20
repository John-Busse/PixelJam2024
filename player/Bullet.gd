extends KinematicBody

var velocity: Vector3 = Vector3.ZERO
var base_speed: float


func _physics_process(_delta):
	velocity = Vector3.FORWARD * (base_speed - PlayerStats.get_surf_speed())
	velocity = move_and_slide(velocity, Vector3.UP)


func init(player_pos: Vector3, bullet_speed: float):
	base_speed = bullet_speed + PlayerStats.get_surf_speed()
	# Set the bullet's position
	translation = player_pos
	# and its velocity
	#velocity = Vector3.FORWARD * bullet_speed


func _on_VisibilityNotifier_screen_exited():
	#despawn the bullet when it leaves the screen
	queue_free()


func _on_MobDetector_body_entered(body: Node):
	PlayerStats.bullet_hit()
	#deal damage to the enemy
	body._take_damage(PlayerStats.get_bullet_damage())
	#despawn this bullet
	queue_free()
