extends Spatial

export var tile_scene: PackedScene
export var scroll_speed: int = 1
var velocity: Vector3
var last_node: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector3.BACK * scroll_speed
	
	last_node = $Pivot/Tile2
	
	spawn_new_tile()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#sliding with direct translation
	for child in $Pivot.get_children():
		child.translation += velocity * delta

# Instantiate a new tile, spawn it above the previous tile
func spawn_new_tile():
	var new_tile: Node = tile_scene.instance()
	var tile_location: Vector3 = last_node.translation + Vector3(0.0, 0.0, -4.8)
	$Pivot.add_child(new_tile)
	new_tile.translation = tile_location
	
	new_tile.connect("offscreen", self, "spawn_new_tile")
	last_node = new_tile
