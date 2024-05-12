extends Spatial


signal offscreen #Emit when this tile is offscreen

func _ready():
	var num_frames: int = $AnimatedSprite3D.frames.get_frame_count("tile")
	$AnimatedSprite3D.frame = randi() % num_frames

#despawn the tile when it gets offscreen, and emit the signal
func _on_VisibilityNotifier_screen_exited():
	emit_signal("offscreen")
	queue_free()
