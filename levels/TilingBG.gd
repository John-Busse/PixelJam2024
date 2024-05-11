extends Spatial


export var tile_scene: PackedScene
export var scroll_speed: int = 1
var velocity: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector3.BACK * scroll_speed
	
	spawn_new_tile()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#sliding with direct translation
	for child in $Pivot.get_children():
		child.translation += velocity * delta


func spawn_new_tile():
	print("spawning new tile")
	var new_tile: Node = tile_scene.instance()
	var tile_location: Vector3 = $Pivot.transform.origin + Vector3(0.0, 0.0, -9.6)
	$Pivot.add_child(new_tile)
	new_tile.translation = tile_location
	
	new_tile.connect("offscreen", self, "spawn_new_tile")
