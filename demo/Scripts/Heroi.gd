extends CharacterBody3D
var Movement    = Vector3.ZERO
var GRAVITY    = -0.8
var Speed   = 20.0
@onready var Pe  = $RayCast3D

func _ready() -> void:
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	var dir = Vector3.ZERO
	if Input.is_action_pressed("ui_up"):
		dir.z -= 1
	if Input.is_action_pressed("ui_down"):
		dir.z += 1
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	dir = dir.normalized()
	
	Movement.x = dir.x * Speed
	Movement.z = dir.z * Speed

	if Pe.is_colliding() and Input.is_action_just_pressed("ui_select"):
		GRAVITY = 7
	if Pe.is_colliding():
		GRAVITY = max(GRAVITY, -0.8)
	GRAVITY += -5 * delta
	Movement.y = GRAVITY

	velocity = Movement
	move_and_slide()
	Movement = velocity
