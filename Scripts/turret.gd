extends Node3D

@onready var camera: Camera3D = get_viewport().get_camera_3d()
@export var rotation_speed: float = 200.0 #Degrees per second

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_position = get_viewport().get_mouse_position()
	
	var ray_origin = camera.project_ray_origin(mouse_position)
	var ray_direction = camera.project_ray_normal(mouse_position)
	
	var ground_plane = Plane(Vector3.UP, 0.0)
	
	var hit_position = ground_plane.intersects_ray(
		ray_origin,
		ray_direction
	)
	
	if hit_position != null:
		var direction = hit_position - global_position
		
		if direction.length_squared() < 0.0001:
			return
		
		direction.y = 0 
		var target_position = global_position + direction
		var target_transform  =  global_transform.looking_at(
			target_position,
			Vector3.UP,
			true
		)
		
		var target_angle = target_transform.basis.get_euler().y
		
		global_rotation.y = rotate_toward(
			global_rotation.y,
			target_angle,
			deg_to_rad(rotation_speed) * delta
		)
