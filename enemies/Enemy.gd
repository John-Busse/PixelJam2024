class_name Enemy
extends KinematicBody


export var min_speed: float
export var max_speed: float
export var damage_value: int
export var health: int
var speed: float
var velocity: Vector3 = Vector3.ZERO


func _initialize(start_pos: Vector3, surf_speed: int):
	pass


func _get_damage_value() -> int:
	return damage_value


func _take_damage(damage: int):
	health -= damage


func _destroyed():
	pass


func _calculate_speed():
	pass
