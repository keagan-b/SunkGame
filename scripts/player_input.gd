extends MultiplayerSynchronizer

@export var player_speed = 5.0
@export var vertical_speed = 2.5

@export var camera: Camera3D
@export var player: CharacterBody3D

@export var vertical_move := false
@export var vertical_dir := 0
@export var use_direction := false

@export var velocities := Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	vertical_move = true
	if Input.is_action_pressed("move_up"):
		vertical_dir = 1
	elif Input.is_action_pressed("move_down"):
		vertical_dir = -1
	else:
		vertical_dir = 0
		vertical_move = false
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	var direction = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	
	# get Y velocity & check for other movement buttons
	var vel_y = -(input_dir.y * camera.rotation.x * vertical_speed)
	if vertical_move:
		if vertical_dir == 1:
			vel_y = vertical_speed
		else:
			vel_y = -vertical_speed

	if vel_y == 0:
		move_toward(player.velocity.y, 0, vertical_speed)

	if direction:
		use_direction = true
		
		# get and check conditions for Z velocity
		var vel_z = 0.0
		
		var camera_rot = snapped(rad_to_deg(camera.rotation.x), 0.01)
		if !(camera_rot == 90.00 or camera_rot == -90.00):
			vel_z = direction.z * player_speed
		
		velocities = Vector3(direction.x * player_speed, vel_y, vel_z)
	else:
		use_direction = false
		velocities = Vector3(move_toward(player.velocity.x, 0, player_speed), vel_y, move_toward(player.velocity.z, 0, player_speed))


func _input(event):
	if event is InputEventMouseMotion:
		print(str(player.player) + ": " + str(deg_to_rad(-event.relative.y * player.mouse_sensitivity)))
			
		# rotate whole body
		player.rotate_y(deg_to_rad(-event.relative.x * player.mouse_sensitivity))
			
		# rotate camera
		camera.rotate_x(deg_to_rad(-event.relative.y * player.mouse_sensitivity))
			
		# clamp camera rotation
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
