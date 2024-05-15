extends KinematicBody

signal die
signal win
export var move_speed: int = 5 #velocity in m/s
var velocity: Vector3 = Vector3.ZERO
var start_pos: Vector3
var game_lost: bool
var game_won: bool
onready var player_stats = get_node("/root/PlayerStats")

func _ready():
	game_lost = false
	game_won = false
	start_pos = translation
	pass


func _physics_process(delta):
	var direction: Vector3 = Vector3.FORWARD
	
	if game_lost:
		velocity = Vector3.ZERO
	elif game_won:
		velocity = Vector3.FORWARD * delta
	else:
		#check for input, update direction
		if Input.is_action_pressed("move_right"):
				direction.x += 1
		if Input.is_action_pressed("move_left"):
			direction.x -= 1
		
		#rotate the player in the direction we're moving
		$Pivot.look_at(global_translation + direction, Vector3.UP)
		
		velocity.x = direction.x * player_stats.get_move_speed()
		#making sure we don't move vertically or upward in case of collisions
		translation.y = start_pos.y
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
	$Pivot/AnimatedSprite3D._set_playing(false)
	print("game won")
	game_lost = true	#to stop the player
	emit_signal("win")
