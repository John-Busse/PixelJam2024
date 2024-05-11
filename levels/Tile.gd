extends Spatial


signal offscreen #Emit when this tile is offscreen


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_VisibilityNotifier_screen_exited():
	print("exited screen")
	emit_signal("offscreen")
	queue_free()
