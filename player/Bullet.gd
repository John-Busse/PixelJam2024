extends KinematicBody

## How fast the bullet travels
export var bullet_speed: int = 10
## How much damage the bullet does
export var bullet_damage: int = 2
var velocity: Vector3 = Vector3.ZERO


func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector3.UP)


func init(player_pos: Vector3):
	# Set the bullet's position
	translation = player_pos
	# and its velocity
	velocity = Vector3.FORWARD * bullet_speed


func _on_VisibilityNotifier_screen_exited():
	#despawn the bullet when it leaves the screen
	queue_free()
