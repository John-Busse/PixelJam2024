extends AnimatedSprite

signal cursor_moved
## The path to the node with the container
export var menu_container_path : NodePath
## Location of the cursor
export var cursor_offset: Vector2 = Vector2(20.0, 0.0)
export var cursor_move_sound: AudioStream
#The node with the container
onready var menu_container := get_node(menu_container_path)

var current_item: int = 0

func _ready():
	if menu_container is VBoxContainer:
		current_item = 0
	elif menu_container is GridContainer:
		current_item = 3

func _process(_delta):
	var input: Vector2 = Vector2.ZERO
	
	if Input.is_action_just_pressed("ui_up"):
		input.y -= 1
	if Input.is_action_just_pressed("ui_down"):
		input.y += 1
	if Input.is_action_just_pressed("ui_left"):
		input.x -= 1
	if Input.is_action_just_pressed("ui_right"):
		input.x += 1

	if menu_container is HBoxContainer:
		set_cursor_pos(current_item)
	if menu_container is VBoxContainer:
		set_cursor_pos(current_item + input.y)
		if input.y != 0:
			$AudioStreamPlayer.play()
	elif menu_container is GridContainer:
		set_cursor_pos(current_item + input.x + input.y * menu_container.columns)
		emit_signal("cursor_moved")
		if input != Vector2.ZERO:
			$AudioStreamPlayer.play()
	
	if Input.is_action_just_pressed("ui_accept"):
		var current_menu_item = get_menu_item(current_item)
		
		if current_menu_item != null:
			if current_menu_item.has_method("cursor_select"):
				current_menu_item.cursor_select()

func get_menu_item(index : int) -> Control:
	#if there's no menu container
	if menu_container == null:
		print("ERR: no menu container")
		return null
	
	# if the index is above the child count
	if index >= menu_container.get_child_count():
		#cycle it around
		index -= menu_container.get_child_count()
	# if the index is below zero
	if index < 0:
		#cycle it around
		index += menu_container.get_child_count()
	
	return menu_container.get_child(index) as Control


func set_cursor_pos(index: int) -> void:
	var menu_item: Control = get_menu_item(index)
	
	if menu_item == null:
		return
	
	var position = menu_item.rect_global_position
	var size = menu_item.rect_size
	
	global_position = Vector2(position.x, position.y + size.y / 2.0) 
	global_position -= (scale / 2.0) + cursor_offset
	
		# if the index is above the child count
	if index >= menu_container.get_child_count():
		#cycle it around
		index -= menu_container.get_child_count()
	# if the index is below zero
	if index < 0:
		#cycle it around
		index += menu_container.get_child_count()
	
	current_item = index


func get_index() -> int:
	return current_item
