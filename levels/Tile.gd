extends Spatial


signal offscreen #Emit when this tile is offscreen

#despawn the tile when it gets offscreen, and emit the signal
func _on_VisibilityNotifier_screen_exited():
	emit_signal("offscreen")
	queue_free()
