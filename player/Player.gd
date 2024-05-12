extends Spatial

export var bullet_scene: PackedScene
var can_fire: bool = true


func _process(_delta):
	if Input.is_action_pressed("fire") and can_fire:
		can_fire = false
		var bullet = bullet_scene.instance()
		
		var spawn_loc: Vector3 = $Surfer.translation
		
		bullet.init(spawn_loc)
		add_child(bullet)
		
		$FireRateTimer.start()


func _on_FireRateTimer_timeout():
	can_fire = true
