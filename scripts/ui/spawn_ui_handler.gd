extends Control

# UI parent reference
@onready var parent: MasterUIHandler = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Footer/RespawnButton.pressed.connect(_on_respawn_pressed)


func _on_respawn_pressed():
	# respawn player
	owner.request_respawn.rpc_id(1)
	parent.respawn()
