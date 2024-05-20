extends Node

signal game_end
export var car_scene: PackedScene
export var truck_scene: PackedScene
export var ped_scene: PackedScene
export var hydrant_scene: PackedScene
export var heli_scene: PackedScene
export var gameplay_music: AudioStream
var car_side: bool
var ped_side: bool
var game_end: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.change_song(gameplay_music)
	PlayerStats.new_stage()
	randomize() #Seed the random generator
	$TilingBG.set_speed(PlayerStats.get_surf_speed())
	$GameUI.init(PlayerStats.get_wave_height(), PlayerStats.get_max_health())
	car_side = randi() % 2
	
	if PlayerStats.get_hydrant_timer() == 0.0:
		$HydrantSpawnTimer.set_paused(true)


func _process(_delta):
	$GameUI.set_dist($TilingBG.get_pivot_dist())
	$GameUI.set_health(PlayerStats.get_health())
	if not game_end:
		$Waves.move_shadow($GameUI.get_height())


func spawn_enemy(this_enemy: PackedScene, spawn_point: Vector3):
	var mob: Node = this_enemy.instance()
	
	spawn_point.y = $RoadPath.translation.y	#Update the y-value
	
	mob._initialize(spawn_point, PlayerStats.get_surf_speed())
	#if the game ends, we need to update the mob speed
	connect("game_end", mob, "_calculate_speed")
	
	add_child(mob)


func spawn_heli():
	var spawn_pos: Vector3 = get_node("Sidewalks/PedSpawn0").translation
	spawn_pos.y = 5.0
	var patrol_pos: Vector3 = get_node("HelicopterPatrol/PatrolPoint1").translation

	var heli: Node = heli_scene.instance()
	heli.init(spawn_pos, patrol_pos, get_node("Player"))
	
	connect("game_end", heli, "game_end")
	
	add_child(heli)


func stop_surfer():
	#the wave stops
	$CarSpawnTimer.set_paused(true)
	$PedSpawnTimer.set_paused(true)
	$HydrantSpawnTimer.set_paused(true)
	emit_signal("game_end")
	game_end = true


func player_die():
	stop_surfer()


func game_over():
	$GameUI.game_over()


func height_zero():
	#stop the wave
	PlayerStats.set_surf_speed(0)
	$TilingBG.set_speed(PlayerStats.get_surf_speed()) 
	stop_surfer()
	$Waves.set_game_won()
	$Player.height_zero()


func game_win():
	$GameUI.game_win()

#spawn a car when this timer ends
func _on_CarSpawnTimer_timeout():
	$CarSpawnTimer.set_wait_time(PlayerStats.get_enemy_timer())
	$CarSpawnTimer.set_one_shot(false)
	$CarSpawnTimer.start(PlayerStats.get_enemy_timer())
	#Get the path node
	var mob_path_node: Node = get_node("RoadPath/PathFollow")
	
	#Find a random spawn point
	var offset: float = randf() / 2.0
	if car_side:	
		# this makes the cars alternate between the left and right sides
		offset += 0.5
	car_side = !car_side	#flip the bool
	
	#set the spawn point
	mob_path_node.unit_offset = offset
	var spawn_point: Vector3 = mob_path_node.translation
	
	var which_scene: PackedScene
	#decide if we're spawning a car or a truck

	#80% chance to spawn a car
	if randf() >= 0.2:
		which_scene = car_scene
	else:	#20% to spawn a truck
		which_scene = truck_scene
		#trucks are longer, so they spawn further up the road
		spawn_point.z -= 1.0
	
	spawn_enemy(which_scene, spawn_point)

#Spawn a pedestrian when this timer ends
func _on_PedSpawnTimer_timeout():
	var mob_path_node: Node
	var offset: Vector3 = Vector3.ZERO
	var num_peds = randi() % 3
	ped_side = randi() % 2
	if ped_side:
		mob_path_node = get_node("Sidewalks/PedSpawn0")
	else:
		mob_path_node = get_node("Sidewalks/PedSpawn1")
	
	for i in num_peds:
		offset.x = rand_range(-0.25, 0.25)
		offset.z = rand_range(-0.5, 0.5)
		spawn_enemy(ped_scene, mob_path_node.translation + offset)
	
	$PedSpawnTimer.set_wait_time(PlayerStats.get_enemy_timer() / 2.0)


func _on_HydrantSpawnTimer_timeout():
	var mob_path_node: Node
	var side: bool = randi() % 2
	if side:
		mob_path_node = get_node("Sidewalks/PedSpawn0")
	else:
		mob_path_node = get_node("Sidewalks/PedSpawn1")
	
	spawn_enemy(hydrant_scene, mob_path_node.translation)
	
	$HydrantSpawnTimer.set_wait_time(PlayerStats.get_hydrant_timer())

#When an active mob enters the wave
func _on_WaveArea_body_entered(body):
	#Deal damage to the wave
	$GameUI.set_height(body._get_damage_value() * -0.5)
	body._destroyed()	#destroy the mob
	
	$AudioStreamPlayer.play()
