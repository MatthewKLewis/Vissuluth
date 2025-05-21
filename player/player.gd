extends CharacterBody3D

@onready var label: Label = $CanvasLayer/AdminPanel/Label
@onready var camera: Camera3D = $Camera3D

const SPEED = 1
const SPEED_FALLOFF: float = .98
const MOUSE_SENSITIVITY = 0.25
const ROLL_SENTITIVITY = 0.15
const GRAVITY = 9.8

var can_shoot = true
var is_dead = false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event: InputEvent) -> void:
	if is_dead:
		return

	if event is InputEventMouseMotion:
		camera.rotation_degrees.x -= event.relative.y * MOUSE_SENSITIVITY
		rotation_degrees.y -= event.relative.x * MOUSE_SENSITIVITY		
		camera.rotation_degrees.z -= event.relative.x * ROLL_SENTITIVITY
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		restart()
	if is_dead:
		return
		
	#Camera Rotation
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -50, 50)
	camera.rotation_degrees.z = clamp(camera.rotation_degrees.z, -50, 50)	
	camera.rotation_degrees.z = lerp(camera.rotation_degrees.z, 0.0, 0.05)
		
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
	#Display Data
	label.text = "Position %v" % position

func _physics_process(delta: float) -> void:
	if is_dead:
		return		
		
	#Magic Carpet Movement
	var input_dir := Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var input3d := Vector3(input_dir.x, 0, input_dir.y)
	
	var direction := (transform.basis * input3d)
	velocity.y += -GRAVITY * delta
	velocity.x += direction.x
	velocity.z += direction.z
	
	if (Input.is_action_pressed("stop")):
		velocity.x *= .9
		velocity.z *= .9
	
	if (move_and_slide()):
		#print("Bonk")
		#velocity *= 0.75 #slide past penalty?
		pass
	
	#bleedoff
	velocity *= 0.98

func restart() -> void:
	get_tree().reload_current_scene()
	
func shoot() -> void:
	pass
