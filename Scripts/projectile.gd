extends Area3D

@export var lifetime: float = 3.0
@export var speed: float = 20.0
@export var damage: float = 25.0

func _ready() -> void:
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var forward = -global_transform.basis.z
	global_position -= forward * speed * delta



func _on_body_entered(body: Node3D) -> void:
	print("Hit: ", body.name)
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free() #delete scene
