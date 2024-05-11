extends KinematicBody


export var bullet_speed: int = 10
var velocity: Vector3 = Vector3.ZERO


func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector3.UP)


func init(player_pos: Vector3):
	translation = player_pos
	velocity = Vector3.FORWARD * bullet_speed
	
