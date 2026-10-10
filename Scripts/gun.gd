extends Node3D

@export var projectile_scene: PackedScene
@onready var muzzle: Marker3D = $Gun_Basic/MuzzlePoint

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("fire"):
		shoot()

func shoot():
	var projectile = projectile_scene.instantiate()
	
	get_tree().current_scene.add_child(projectile)
	projectile.global_transform = muzzle.global_transform
