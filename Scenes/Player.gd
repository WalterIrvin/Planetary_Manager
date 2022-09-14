extends KinematicBody
var max_speed = 12
var velocity = Vector3.ZERO
var sensitivity = 0.25
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif Input.is_action_just_pressed("ui_accept"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var movement = event.relative
		rotation.x += clamp(-deg2rad(movement.y * sensitivity), deg2rad(-80), deg2rad(80))
		rotation.y += -deg2rad(movement.x * sensitivity)
	
func _physics_process(delta):
	var input_vec = _get_input_vector()
	apply_movement(input_vec)
	velocity = move_and_slide(velocity, Vector3.UP)
	
func _get_input_vector():
	# X: right/left, Y: Up/Down, Z: Forward/Backward
	var input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	input_vector.y = Input.get_action_strength("jump") - Input.get_action_strength("crouch")
	return input_vector.normalized()
	

func apply_movement(vec):
	#Apply movement to Forward/Right vector of object
	var side = global_transform.basis.x
	var up = global_transform.basis.y
	var facing = global_transform.basis.z
	velocity = facing * max_speed * vec.z
	velocity += up * max_speed * vec.y
	velocity += side * max_speed * vec.x
