extends CharacterBody3D

@export var move_speed: float = 3.0 
@export var player: CharacterBody3D
@export var mass: float = 3.0 
@export var rotation_speed: float = 90.0 

var push_velocity: Vector3 = Vector3.ZERO

func push(direction: Vector3, force: float) -> void:
	push_velocity = direction * force
	
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if player == null:
		move_and_slide()
		return	
	
	var direction = player.global_position - global_position
	direction.y = 0.0
	direction = direction.normalized()
	
	velocity.x = direction.x * move_speed + push_velocity.x
	velocity.z = direction.z * move_speed + push_velocity.z
	
	var target_angle = atan2(-direction.x, -direction.z)
	
	move_and_slide()
	
	rotation.y = rotate_toward(
		rotation.y,
		target_angle,
		deg_to_rad(rotation_speed) * delta
	)
	
	push_velocity = push_velocity.move_toward(
		Vector3.ZERO,
		10.0 * delta
	)
