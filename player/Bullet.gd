extends KinematicBody

var velocity: Vector3 = Vector3.ZERO
onready var player_stats = get_node("/root/PlayerStats")


func _physics_process(_delta):
	velocity = move_and_slide(velocity, Vector3.UP)


func init(player_pos: Vector3, bullet_speed: float):
	# Set the bullet's position
	translation = player_pos
	# and its velocity
	velocity = Vector3.FORWARD * bullet_speed


func _on_VisibilityNotifier_screen_exited():
	#despawn the bullet when it leaves the screen
	queue_free()


func _on_MobDetector_body_entered(body: Node):
	player_stats.bullet_hit()
	#deal damage to the enemy
	body._take_damage(player_stats.get_bullet_damage())
	#despawn this bullet
	queue_free()
