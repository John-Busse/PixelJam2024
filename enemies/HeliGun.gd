extends Spatial

export var heli_bullet: PackedScene
var player_node: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	$HeliMob/HeliCannon.look_at(player_node.translation, Vector3.UP)


func init(start_pos: Vector3, target_pos: Vector3, player: Node):
	$HeliMob.init_heli(start_pos, target_pos, player)
	player_node = player


func _on_Helicopter_can_fire():
	$HeliWeaponTimer.start()


func _on_HeliWeaponTimer_timeout():
	var bullet = heli_bullet.instance()
	var spawn_loc: Vector3 = $HeliMob.translation - Vector3(0.0, -0.2, 0.0)
	
	bullet.init(spawn_loc, player_node.translation)
	add_child(bullet)
	
		#play helicopter firing sound
	$HeliWeaponTimer.start()

# Enemy leaves the screen
func _on_VisibilityNotifier_screen_exited():
	queue_free()

func game_end():
	$HeliWeaponTimer.set_paused(true)
