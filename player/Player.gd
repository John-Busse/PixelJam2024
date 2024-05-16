extends Spatial

#signal hit
signal die
signal game_over
signal win
export var bullet_scene: PackedScene
var can_fire: bool = true


func _ready():
	$FireRateTimer.set_wait_time(PlayerStats.get_fire_rate())


func _process(_delta):
	#When the player presses the fire button
	if Input.is_action_pressed("fire") and can_fire:
		PlayerStats.bullet_fired()
		can_fire = false
		var bullet = bullet_scene.instance()
		
		var spawn_loc: Vector3 = $Surfer.translation
		
		bullet.init(spawn_loc, PlayerStats.get_bullet_speed())
		add_child(bullet)
		
			## play fire sound
		#start fire rate time
		$FireRateTimer.start()


func _on_FireRateTimer_timeout():
	can_fire = true

#Stop the player from being able to fire when the game ends
func stop_weapon():
	$FireRateTimer.set_paused(true)
	can_fire = false


func die():
	stop_weapon()
	emit_signal("die")
	$Surfer.die()

#This is a passthrough function to propogate the game_over signal to the level
func game_over():
	emit_signal("game_over")


func height_zero():
	stop_weapon()
	$Surfer.height_zero()

#This is a passthrough function to propogate the win signal to the level
func win():
	emit_signal("win")

#When the player is hit by a mob
func _on_MobDetector_body_entered(body: Node):
	PlayerStats.take_damage(body._get_damage_value())
	body._destroyed()
	#emit_signal("hit")
	if PlayerStats.health == 0:
		die()
