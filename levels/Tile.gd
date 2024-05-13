extends Spatial


signal offscreen #Emit when this tile is offscreen
export var tile_name: String

func _ready():
	var num_frames: int = $AnimatedSprite3D.frames.get_frame_count(tile_name)
	$AnimatedSprite3D.set_animation(tile_name)
	$AnimatedSprite3D.set_frame(randi() % num_frames)

#despawn the tile when it gets offscreen, and emit the signal
func _on_VisibilityNotifier_screen_exited():
	emit_signal("offscreen")
	queue_free()
