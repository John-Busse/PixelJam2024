extends Spatial

var game_won: bool = false

func _ready():
	#Make sure the shadow and wave are on the same animation frame
	$Shadow/WaveShadow.set_frame($WaveTop.get_frame())

func _process(delta):
	if game_won:
		$WaveTop.translation.z += 1.0 * delta
		$Shadow.translation.z += 1.0 * delta


func move_shadow(height: float):
	var scaled_height: float = height * 4.8 / 200
	$Shadow.translation.z = 0.5 - scaled_height


func set_game_won():
	game_won = true


func _on_VisibilityNotifier_screen_exited():
	queue_free()
