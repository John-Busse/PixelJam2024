extends Label

signal cursor_selected()
export var scene_path: String

func cursor_select():
	emit_signal("cursor_selected")
