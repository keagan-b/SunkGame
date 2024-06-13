extends CharacterBody3D

@export var player := 1 :
	set(id):
		player = id
		$PlayerInput.set_multiplayer_authority(id)

# references
@onready var input = $PlayerInput
@onready var camera = $PlayerCamera

# modifiable variables
@export var mouse_sensitivity = 0.4

# player variables/information
@export var is_alive = true

# movement variables
var target_velocity = Vector3.ZERO

func _ready():
	if player == multiplayer.get_unique_id():
		print("Client connected: " + str(multiplayer.get_unique_id()))
		camera.make_current()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		$LookIndicator.set_visible(false)
	else:
		camera.current = false
		

func _physics_process(_delta):
	if input.use_direction:
		velocity.x = input.velocities.x
		velocity.z = input.velocities.z
			
		if !input.vertical_move:
			velocity.y =  input.velocities.y
		
	else:
		velocity.x = input.velocities.x
		velocity.z = input.velocities.z
	
	if !input.vertical_move and !input.use_direction:
		velocity.y = input.velocities.y
	
	# apply camera rotations
	rotate_y(input.camera_rotations.y)
	camera.rotate_x(input.camera_rotations.x)
	
	# clamp camera rotation
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

	# apply movement
	move_and_slide()
