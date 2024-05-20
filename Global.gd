extends Node

var current_scene = null
var save_file: String = "res://save/savegame.save"

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.set_window_size(Vector2(1024, 768))
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)


func goto_scene(path: String):
	#make the scene transition deferred to avoid walking over
	# other code execution
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path: String):
	#remove the current scene
	current_scene.free()
	
	#Load the new scene
	var new_scene = ResourceLoader.load(path)
	
	#Create an instance of it
	current_scene = new_scene.instance()
	
	#add it to the tree
	get_tree().root.add_child(current_scene)
	
	get_tree().current_scene = current_scene


func change_song(song: AudioStream):
	# if this song is a new song
	if $MusicPlayer.get_stream() != song:
		$MusicPlayer.set_stream(song)
		$MusicPlayer.play()


func save_game():
	var save_game = File.new()
	save_game.open(save_file, File.WRITE)
	var save_data = PlayerStats.save_game()
	save_game.store_line(to_json(save_data))
	save_game.close()


func load_game() -> bool:
	var save_game = File.new()
	if not save_game.file_exists(save_file):
		return false
	
	save_game.open(save_file, File.READ)
	#while save_game.get_position() < save_game.get_len():
	var save_data = parse_json(save_game.get_line())
	PlayerStats.load_game(save_data)
	
	return true
