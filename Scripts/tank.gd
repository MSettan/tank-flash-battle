extends CharacterBody3D

const move_speed = 5.0
const rotation_speed = 2


	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var move_input := Input.get_axis("move_forward", "move_backward")
	var turn_input := Input.get_axis("turn_left", "turn_right")
	
	rotation.y -= turn_input * rotation_speed * delta
	
	var forward = -transform.basis.z
	
	velocity.x = forward.x * move_input * move_speed
	velocity.z = forward.z * move_input * move_speed
	

	move_and_slide()
