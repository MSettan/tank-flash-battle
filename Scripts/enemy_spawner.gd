extends Node3D

@export var enemy_scene: PackedScene
@export var player: CharacterBody3D
@export var min_spawn_distance: float = 1.0
@export var max_spawn_distance: float = 10.0
@export var navigation_region: NavigationRegion3D

func spawn_enemy() -> void:
	var enemy = enemy_scene.instantiate()
	
	enemy.player = player
	get_parent().add_child.call_deferred(enemy)
	
	await enemy.tree_entered
	
	enemy.global_position = get_random_spawn_position()
	
	print("Enemy spawned at: ", enemy.global_position)
	

	
func get_random_spawn_position() -> Vector3:
	var angle = randf_range(0.0, TAU)
	var distance = randf_range(min_spawn_distance, max_spawn_distance)
	
	var offset = Vector3(
		cos(angle) * distance,
		0.0,
		sin(angle) * distance
	)
	
	var random_position = player.global_position + offset
	
	var nav_map = navigation_region.get_navigation_map()
	var valid_position = NavigationServer3D.map_get_closest_point(
		nav_map,
		random_position
	)
	
	print("Region enabled: ", navigation_region.enabled)
	print("Has NavigationMesh: ", navigation_region.navigation_mesh != null)
	print("Map iteration: ", NavigationServer3D.map_get_iteration_id(nav_map))
	print("Closest point: ", valid_position)
	
	return valid_position



func _ready() -> void:
	#var nav_map = get_world_3d().navigation_map
	#while NavigationServer3D.map_get_iteration_id(nav_map) == 0:
	#	await get_tree().physics_frame
	
	await get_tree().create_timer(0.1).timeout
	
	for i in range(5):
		spawn_enemy()
