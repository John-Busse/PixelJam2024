extends Spatial

signal offscreen #Emit when this tile is offscreen
export var tile_name: String
var surf_sign_on: bool = false
var building_one_on: bool = false
var building_two_on: bool = false


func _ready():
	var num_frames: int = $AnimatedSprite3D.frames.get_frame_count(tile_name)
	$AnimatedSprite3D.set_animation(tile_name)
	$AnimatedSprite3D.set_frame(randi() % num_frames)
	
	if $AnimatedSprite3D.animation == "transition":
		$SurfSign.translation.y = 3.0
	elif $AnimatedSprite3D.animation == "tile" && $AnimatedSprite3D.frame == 0:
		$Tile0Buildings.translation.y = 3.0


func _process(_delta):
	if surf_sign_on:
		$SurfSign/SignParticles.global_translation.z = 1.25
	if building_one_on:
		$Tile0Buildings/Building1/Building1Particles.global_translation.z = 1.25
	if building_two_on:
		$Tile0Buildings/Building2/Building2Particles.global_translation.z = 1.25

#despawn the tile when it gets offscreen, and emit the signal
func _on_VisibilityNotifier_screen_exited():
	emit_signal("offscreen")
	queue_free()


func _on_SurfSign_area_entered(_area):
	$SurfSign/SignParticles.set_emitting(true)
	surf_sign_on = true


func _on_SurfSign_area_exited(_area):
	$SurfSign/SignParticles.set_emitting(false)
	surf_sign_on = false


func _on_Building1_area_entered(_area):
	$Tile0Buildings/Building1/Building1Particles.set_emitting(true)
	building_one_on = true


func _on_Building1_area_exited(_area):
	$Tile0Buildings/Building1/Building1Particles.set_emitting(false)
	building_one_on = false


func _on_Building2_area_entered(_area):
	$Tile0Buildings/Building2/Building2Particles.set_emitting(true)
	building_two_on = true


func _on_Building2_area_exited(_area):
	$Tile0Buildings/Building2/Building2Particles.set_emitting(false)
	building_two_on = false
