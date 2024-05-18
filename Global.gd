extends Node

export var menu_loop: AudioStream
export var gameplay_loop: AudioStream
var current_scene = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	#change_song(menu_loop)


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
	$MusicPlayer.set_stream(song)
	$MusicPlayer.play()
