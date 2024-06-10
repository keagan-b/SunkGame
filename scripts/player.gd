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

@export var health = 100.0


# movement variables
var target_velocity = Vector3.ZERO

func _ready():
	if player == multiplayer.get_unique_id():
		camera.current = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
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

	move_and_slide()
