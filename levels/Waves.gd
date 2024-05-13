extends Spatial


func _ready():
	#Make sure the shadow and wave are on the same animation frame
	$WaveShadow.set_frame($WaveBottom.get_frame())

