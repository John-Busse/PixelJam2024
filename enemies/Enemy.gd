class_name Enemy
extends KinematicBody


export var min_speed: float
export var max_speed: float
var speed: float
var velocity: Vector3 = Vector3.ZERO
export var damage_value: int
export var health: int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _initialize(start_pos: Vector3, end_pos: Vector3):
	pass


func _get_damage_value() -> int:
	return 0


func _take_damage(damage: int):
	health -= damage


func _destroyed():
	pass
