extends KinematicBody

signal hit
export var move_speed: int = 5 #velocity in m/s
var velocity: Vector3 = Vector3.ZERO


func _physics_process(delta):
	var direction: Vector3 = Vector3.FORWARD
	
	#check for input, update direction
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	
	#rotate the player in the direction we're moving
	$Pivot.look_at(translation + direction, Vector3.UP)
	
	velocity.x = direction.x * move_speed
	#making sure we don't move vertically or upward
	velocity.y = 0.0
	velocity.z = 0.0
	
	velocity = move_and_slide(velocity, Vector3.UP)
