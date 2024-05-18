extends Spatial


var game_over: bool = false
var game_won: bool = false

func _ready():
	#Make sure the shadow and wave are on the same animation frame
	$Shadow/WaveShadow.set_frame($WaveTop.get_frame())

func _process(delta):
	if game_over:
		$WaveTop.translation.z += PlayerStats.get_surf_speed() * delta
		$Shadow.translation.z += PlayerStats.get_surf_speed() * delta
	elif game_won:
		$WaveTop.translation.z -= PlayerStats.get_surf_speed() * delta
		$Shadow.translation.z -= PlayerStats.get_surf_speed() * delta


func move_shadow(height: float):
	var scaled_height: float = height * 4.8 / 200
	$Shadow.translation.z = 0.5 - scaled_height


func set_game_over():
	game_over = true


func set_game_won():
	game_won = true
