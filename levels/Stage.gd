extends Node

signal game_end
export var car_scene: PackedScene
export var ped_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerStats.new_stage()
	randomize() #Seed the random generator
	$TilingBG.set_speed(PlayerStats.get_surf_speed())
	$GameUI.init(PlayerStats.get_wave_height(), PlayerStats.get_max_health())


func _process(_delta):
	$GameUI.set_dist($TilingBG.get_pivot_dist())
	$GameUI.set_health(PlayerStats.get_health())
	$Waves.move_shadow($GameUI.get_height())


func spawn_enemy(this_enemy: PackedScene, path_node: String):
	var mob: Node = this_enemy.instance()
	
	#Get the path node
	var mob_path_node: Node = get_node(path_node)
	#Choose a spawn location along the path
	mob_path_node.unit_offset = randf()
	var spawn_loc: Vector3 = mob_path_node.translation
	spawn_loc.y = $RoadPath.translation.y	#update the y-value
	#choose a destination location along the path
	mob_path_node.unit_offset = randf()
	var dest_loc: Vector3 = mob_path_node.translation
	dest_loc.y = $RoadPath.translation.y	#Update the y-value
	
	mob._initialize(spawn_loc, PlayerStats.get_surf_speed())
	#if the game ends, we need to update the mob speed
	connect("game_end", mob, "_calculate_speed")
	
	add_child(mob)


func stop_surfer():
	#Stop the wave
	PlayerStats.set_surf_speed(0)
	$TilingBG.set_speed(PlayerStats.get_surf_speed()) 
	$CarSpawnTimer.set_paused(true)
	$PedSpawnTimer.set_paused(true)
	emit_signal("game_end")


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
