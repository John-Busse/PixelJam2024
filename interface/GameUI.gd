extends Control

signal game_over
signal height_zero
var distance_value: float = 0.0
var height_value: int
var speed: int


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func init(height: int):
	height_value = height
	distance_value = 0.0


#func _process(delta):
#	distance_value += speed * delta
#	print("distance is ", distance_value)
#
#	var dist: String = String(distance_value as int)
#
#	$GridContainer/DistValue.text = str(dist + " m")


func set_speed(new_speed: int):
	speed = new_speed

#Set the distance, based on distance from the tile origin
func set_dist(origin: float):
	origin *= 100.0 / 4.8
	
	var dist: String = String(origin as int)
	
	$GridContainer/DistValue.text = str(dist + " m")
