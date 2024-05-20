extends KinematicBody


var velocity: Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	var speed = randf() * 5.0 + 2.0
	var angle = randf() * PI + PI
	velocity.x = cos(angle)
	velocity.z = sin(angle)
	velocity = velocity.normalized() * speed


func _physics_process(delta):
	move_and_slide(velocity, Vector3.UP)
