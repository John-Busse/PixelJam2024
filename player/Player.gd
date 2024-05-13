extends Spatial

#signal hit
signal die
signal game_over
signal win
export var bullet_scene: PackedScene
var can_fire: bool = true
onready var player_stats = get_node("/root/PlayerStats")


func _ready():
	$FireRateTimer.set_wait_time(player_stats.get_fire_rate())


func _process(_delta):
	#When the player presses the fire button
	if Input.is_action_pressed("fire") and can_fire:
		player_stats.bullet_fired()
		can_fire = false
		var bullet = bullet_scene.instance()
		
		var spawn_loc: Vector3 = $Surfer.translation
		
		bullet.init(spawn_loc, player_stats.get_bullet_speed())
		add_child(bullet)
		
			## play fire sound
		#start fire rate time
		$FireRateTimer.start()


func _on_FireRateTimer_timeout():
	can_fire = true


func die():
	emit_signal("die")
	$Surfer.die()


func game_over():
	emit_signal("game_over")


func height_zero():
	$Surfer.height_zero()

func win():
	emit_signal("win")

#When the player is hit by a mob
func _on_MobDetector_body_entered(body: Node):
	player_stats.take_damage(body._get_damage_value())
	body._destroyed()
	#emit_signal("hit")
	if player_stats.health == 0:
		die()
