extends Label

#signal cursor_selected()
export var scene_path: String

func cursor_select():
	print(name)
	Global.goto_scene(scene_path)
