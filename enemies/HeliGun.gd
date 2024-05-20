extends Spatial

export var heli_bullet: PackedScene
export var heli_shoot_0: AudioStream
export var heli_shoot_1: AudioStream
var player_node: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func init(start_pos: Vector3, target_pos: Vector3, player: Node):
	$HeliMob.init_heli(start_pos, target_pos, player)
	player_node = player


func _on_Helicopter_can_fire():
	$HeliWeaponTimer.set_paused(false)
	$HeliWeaponTimer.start()


func _on_HeliWeaponTimer_timeout():
	var bullet = heli_bullet.instance()
	var spawn_loc: Vector3 = $HeliMob.translation + Vector3(0.0, -1.0, 0.0)
	
	bullet.init(spawn_loc, player_node.translation)
	add_child(bullet)
	
	#play the bullet sound
	var i: int = randi() % 2
	match i:
		0:
			$HeliBulletAudioPlayer.set_stream(heli_shoot_0)
		1:
			$HeliBulletAudioPlayer.set_stream(heli_shoot_1)
	
	$HeliBulletAudioPlayer.play()
	$HeliWeaponTimer.start()

# Enemy leaves the screen
func _on_VisibilityNotifier_screen_exited():
	queue_free()


func game_end():
	$HeliWeaponTimer.set_paused(true)
