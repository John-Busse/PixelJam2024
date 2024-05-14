extends Node

### HANDLE ENEMY SPAWNS IN THIS SCRIPT
export var car_scene: PackedScene
export var ped_scene: PackedScene
onready var player_stats = get_node("/root/PlayerStats")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize() #Seed the random generator
	$TilingBG.set_speed(player_stats.get_surf_speed())
	$GameUI.init(player_stats.get_wave_height(), player_stats.get_max_health())


func _process(_delta):
	$GameUI.set_dist($TilingBG.get_pivot_dist())
	$GameUI.set_health(player_stats.get_health())
	$Waves.move_shadow($GameUI.get_height())


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


func stop_surfer():
	#Stop the wave
	player_stats.set_surf_speed(0)
	$TilingBG.set_speed(player_stats.get_surf_speed()) 
	$CarSpawnTimer.set_paused(true)
	$PedSpawnTimer.set_paused(true)


func player_die():
	stop_surfer()
	## Wave starts to slide up the screen


func game_over():
	$GameUI.game_over()


func height_zero():
	stop_surfer()
	##Wave slides down the screen
	$Player.height_zero()


func game_win():
	$GameUI.game_win()

#spawn a car when this timer ends
func _on_CarSpawnTimer_timeout():
	spawn_enemy(car_scene, "RoadPath/PathFollow")
	$CarSpawnTimer.set_wait_time(2.0)
	pass # Replace with function body.

#Spawn a pedestrian when this timer ends
func _on_PedSpawnTimer_timeout():
	#spawn_enemy(ped_scene)
	pass # Replace with function body.

#When an active mob enters the wave
func _on_WaveArea_body_entered(body):
	#Deal damage to the wave
	$GameUI.set_height(body._get_damage_value() * -1)
	body._destroyed()	#destroy the mob
