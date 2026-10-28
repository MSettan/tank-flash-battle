extends CharacterBody3D

@export var move_speed: float = 3.0 
@export var player: CharacterBody3D
@export var mass: float = 3.0 
@export var rotation_speed: float = 90.0 

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
@onready var navigation_timer: Timer = $NavigationTimer

var push_velocity: Vector3 = Vector3.ZERO

func push(direction: Vector3, force: float) -> void:
	push_velocity = direction * force
	
func _ready() -> void:
	navigation_timer.start(randf_range(0.5, 1))
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if player == null:
		move_and_slide()
		return	
	
	var next_position = navigation_agent.get_next_path_position()
	var direction = next_position - global_position
	
	var nav_map = navigation_agent.get_navigation_map()
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
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider.is_in_group("enemies"):
			var push_direction = -collision.get_normal()
			collider.push(push_direction, 5.0)
	
	push_velocity = push_velocity.move_toward(
		Vector3.ZERO,
		10.0 * delta
	)


func _on_navigation_timer_timeout() -> void:
	if player == null:
		return
	
	navigation_agent.target_position = player.global_position
