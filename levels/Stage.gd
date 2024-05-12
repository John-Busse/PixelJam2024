extends Node

### HANDLE ENEMY SPAWNS IN THIS SCRIPT
export var car_scene: PackedScene
export var ped_scene: PackedScene
export var surf_speed: int = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	$TilingBG.set_speed(surf_speed)
	randomize() #Seed the random generator


func _process(_delta):
	$GameUI.set_dist($TilingBG.get_pivot_dist())


func spawn_enemy(this_enemy: PackedScene, path_node: String):
	var mob: Node = this_enemy.instance()
	
	#Get the path node
	var mob_path_node: Node = get_node(path_node)
	#Choose a spawn location along the path
	mob_path_node.unit_offset = randf()
	var spawn_loc: Vector3 = mob_path_node.translation
	spawn_loc.y = 2.0	#update the y-value
	#choose a destination location along the path
	mob_path_node.unit_offset = randf()
	var dest_loc: Vector3 = mob_path_node.translation
	dest_loc.y = 2.0	#Update the y-value
	
	mob._initialize(spawn_loc, dest_loc)
	
	add_child(mob)


func game_over():
	surf_speed = 0
	$TilingBG.set_speed(surf_speed) #Stop the player
	# Player crashes into the wave
	# Wave slides up the screen
	# Game Over text appears with button


func game_win():
	surf_speed = 0
	$TilingBG.set_speed(surf_speed)
	#Wave slides down the screen
	#Player moves up the screen and beams out
	# Victory text appears with button
	pass


func _on_CarSpawnTimer_timeout():
	spawn_enemy(car_scene, "RoadPath/PathFollow")
	$CarSpawnTimer.set_wait_time(2.0)
	pass # Replace with function body.


func _on_PedSpawnTimer_timeout():
	#spawn_enemy(ped_scene)
	pass # Replace with function body.
