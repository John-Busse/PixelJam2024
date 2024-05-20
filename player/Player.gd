extends Spatial
# This script mainly handles the bullets
#and it has a lot of passthrough to the surfer object
signal die
signal game_over
signal win
export var bullet_scene: PackedScene
export var gun_sound_0: AudioStream
export var gun_sound_1: AudioStream
export var gun_sound_2: AudioStream
export var player_hurt_0: AudioStream
export var player_hurt_1: AudioStream
export var player_hurt_2: AudioStream
var can_fire: bool = true
var is_firing: bool = false
var is_dead: bool = false
var offset: Vector3 = Vector3(-0.13, -0.1, -0.75)


func _ready():
	$FireRateTimer.set_wait_time(PlayerStats.get_fire_rate())


func _process(_delta):
	#When the player presses the fire button
	if Input.is_action_pressed("fire") and can_fire:
		PlayerStats.bullet_fired()
		$Surfer.gunshot()
		$FireRateTimer.start()
		can_fire = false
		is_firing = true


func shoot_bullet():
	if is_firing:
		is_firing = false
		var bullet = bullet_scene.instance()
		
		var spawn_loc: Vector3 = $Surfer.translation + offset
		
		var i: int = randi() % 3
		match i:
			0:
				$AudioStreamPlayer.set_stream(gun_sound_0)
			1:
				$AudioStreamPlayer.set_stream(gun_sound_1)
			2:
				$AudioStreamPlayer.set_stream(gun_sound_2)
		
		$AudioStreamPlayer.play()
		
		bullet.init(spawn_loc, PlayerStats.get_bullet_speed())
		add_child(bullet)


func _on_FireRateTimer_timeout():
	can_fire = true

#Stop the player from being able to fire when the game ends
func stop_weapon():
	$FireRateTimer.set_paused(true)
	can_fire = false


func die():
	if not is_dead:
		is_dead = true
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
	if body._get_damage_value() > 0:
		PlayerStats.take_damage(body._get_damage_value())
		body._destroyed()
		
		match randi() % 3:
			0:
				$Surfer/PlayerHit.set_stream(player_hurt_0)
			1:
				$Surfer/PlayerHit.set_stream(player_hurt_1)
			2:
				$Surfer/PlayerHit.set_stream(player_hurt_2)
		$Surfer/PlayerHit.play()
		#emit_signal("hit")
		if PlayerStats.get_health() == 0:
			die()


func get_player_pos() -> Vector3:
	return $Surfer.global_translation
