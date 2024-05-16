extends Node

signal game_end
export var car_scene: PackedScene
export var ped_scene: PackedScene
var car_side: bool
var ped_side: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerStats.new_stage()
	randomize() #Seed the random generator
	$TilingBG.set_speed(PlayerStats.get_surf_speed())
	$GameUI.init(PlayerStats.get_wave_height(), PlayerStats.get_max_health())
	car_side = randi() % 2
	ped_side = randi() % 2
	
	if PlayerStats.get_hydrant_timer() == 0.0:
		$HydrantSpawnTimer.set_paused(true)


func _process(_delta):
	$GameUI.set_dist($TilingBG.get_pivot_dist())
	$GameUI.set_health(PlayerStats.get_health())
	$Waves.move_shadow($GameUI.get_height())


func spawn_enemy(this_enemy: PackedScene, spawn_point: Vector3):
	var mob: Node = this_enemy.instance()
	
	spawn_point.y = $RoadPath.translation.y	#Update the y-value
	
	mob._initialize(spawn_point, PlayerStats.get_surf_speed())
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
	#Get the path node
	var mob_path_node: Node = get_node("RoadPath/PathFollow")
	#Find a random spawn point
	var offset: float = randf() / 2.0
	if car_side:	# this makes the cars alternate between the left and right sides
		offset += 0.5
	
	car_side = !car_side	#flip the bool
	#set the spawn point
	mob_path_node.unit_offset = offset
	spawn_enemy(car_scene, mob_path_node.translation)
	$CarSpawnTimer.set_wait_time(PlayerStats.get_enemy_timer())

#Spawn a pedestrian when this timer ends
func _on_PedSpawnTimer_timeout():
	var mob_path_node: Node
	var offset: Vector3 = Vector3.ZERO
	var num_peds = randi() % 3
	if ped_side:
		mob_path_node = get_node("SpawnRef/Sidewalks/PedSpawn0")
	else:
		mob_path_node = get_node("SpawnRef/Sidewalks/PedSpawn1")
	
	for i in num_peds:
		offset.x = rand_range(-0.25, 0.25)
		spawn_enemy(ped_scene, mob_path_node.translation + offset)
	
	$PedSpawnTimer.set_wait_time(PlayerStats.get_enemy_timer() / 2.0)

#When an active mob enters the wave
func _on_WaveArea_body_entered(body):
	#Deal damage to the wave
	$GameUI.set_height(body._get_damage_value() * -1)
	body._destroyed()	#destroy the mob
