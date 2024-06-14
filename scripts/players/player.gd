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

# movement variables
var target_velocity = Vector3.ZERO

func _ready():
	# set multiplayer input constraints
	if player == multiplayer.get_unique_id():
		print("Spawned character " + str(multiplayer.get_unique_id()))
		
		# set camera mode
		camera.make_current()
		
		# lock mouse
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		$LookIndicator.set_visible(false)
		
		# connect signals
		$OxygenComponent.connect("out_of_oxygen", _out_of_oxygen)
		$HealthComponent.connect("has_died", _has_died)
	else:
		camera.queue_free()

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
	
	# ensure camera wasn't freed
	if camera != null:
		camera.rotate_x(input.camera_rotations.x)
	
		# clamp camera rotation
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

	# apply movement
	move_and_slide()


# out of oxygen event handler
func _out_of_oxygen():
	pass


# has died event handler
func _has_died():
	# disable user movement
	input.set_process(false)
	
	# spawn "dead body" here
	
	# request removal
	get_parent().get_parent().request_removal.rpc_id(1)
	
