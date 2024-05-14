extends Spatial


func _ready():
	#Make sure the shadow and wave are on the same animation frame
	$WaveShadow.set_frame($WaveBottom.get_frame())


func move_shadow(height: float):
	var scaled_height: float = height * 4.8 / 100
	$WaveShadow.translation.z = 0.5 - scaled_height
