extends Node

### HANDLE ENEMY SPAWNS IN THIS SCRIPT
export var car_scene: PackedScene
export var ped_scene: PackedScene

## Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
