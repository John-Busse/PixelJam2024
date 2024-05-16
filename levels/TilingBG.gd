extends Spatial

export var tile_scene: PackedScene
var velocity: Vector3
var last_node: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	last_node = $Pivot/Tile2
	
	spawn_new_tile()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#sliding with direct translation
	$Pivot.translation += velocity * delta


func set_speed(new_speed: int):
	velocity = Vector3.BACK * new_speed

# Instantiate a new tile, spawn it above the previous tile
func spawn_new_tile():
	var new_tile: Node = tile_scene.instance()
	var tile_location: Vector3 = last_node.translation + Vector3(0.0, 0.0, -6.4)
	$Pivot.add_child(new_tile)
	new_tile.translation = tile_location
	#new_tile.init()
	
	new_tile.connect("offscreen", self, "spawn_new_tile")
	last_node = new_tile

func get_pivot_dist() -> float:
	return $Pivot.translation.z
