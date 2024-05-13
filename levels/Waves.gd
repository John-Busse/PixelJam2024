extends Spatial


export var wave_speed: float = 0.1


func _ready():
	#Make sure the shadow and wave are on the same animation frame
	$UpperLayer/WaveShadow.frame = $UpperLayer/WaveTop.frame


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	$UpperLayer.translation.z += wave_speed * delta
#
#	if $UpperLayer.translation.z > 0.2 or $UpperLayer.translation.z < 0.1:
#		wave_speed *= -1
	pass
