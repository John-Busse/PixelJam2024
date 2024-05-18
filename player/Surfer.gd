extends KinematicBody

signal die
signal win
signal shoot
export var move_speed: int = 5 #velocity in m/s
var velocity: Vector3 = Vector3.ZERO
var start_pos: Vector3
var game_lost: bool = false
var game_won: bool = false
var is_shooting: bool = false

func _ready():
	start_pos = translation


func _process(_delta):
	if $Pivot/AnimatedSprite3D.get_animation() == "surf_shoot" and $Pivot/AnimatedSprite3D.get_frame() == 2:
		emit_signal("shoot")

func _physics_process(delta):
	var direction: Vector3 = Vector3.FORWARD
	
	if game_lost or game_won:
		velocity = Vector3.ZERO
#	elif game_won:
#		velocity = Vector3.FORWARD * PlayerStats.get_surf_speed()# * delta
	else:
		#check for input, update direction
		if Input.is_action_pressed("move_right"):
			direction.x += 1
		if Input.is_action_pressed("move_left"):
			direction.x -= 1
		
		# change animation to match movement
		if direction.x == 0 and not is_shooting:
			$Pivot/AnimatedSprite3D.set_animation("surf_straight")
		elif direction.x > 0 and not is_shooting:
			$Pivot/AnimatedSprite3D.set_animation("surf_right")
		elif direction.x < 0 and not is_shooting:
			$Pivot/AnimatedSprite3D.set_animation("surf_left")
		else:
			$Pivot/AnimatedSprite3D.set_animation("surf_shoot")
		
		velocity.x = direction.x * PlayerStats.get_move_speed()
		#making sure we don't move vertically in case of collisions
		translation.z = start_pos.z
	
	velocity = move_and_slide(velocity, Vector3.UP)


func die():
	game_lost = true
	#start the game over animation
	start_animation("game_over")


func game_over():
	emit_signal("die")


func height_zero():
	game_won = true
	#start the game won animation
	start_animation("game_win")


func start_animation(anim_name: String):
	$Pivot/AnimatedSprite3D.set_animation(anim_name)
	$Pivot/AnimatedSprite3D._set_playing(true)
	$Pivot/AnimatedSprite3D.connect("animation_finished", self, anim_name)


func game_win():
	$Pivot/AnimatedSprite3D.set_animation("game_win_loop")
	print("game won")
	game_lost = true	#to stop the player
	emit_signal("win")


func gunshot():
	is_shooting = true


func _on_AnimatedSprite3D_animation_finished():
	if $Pivot/AnimatedSprite3D.get_animation() == "surf_shoot":
		is_shooting = false
