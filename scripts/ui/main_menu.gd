extends Control

const PORT = 7777


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$ConnectButton.pressed.connect(self._on_connect_button_pressed)
	$HostButton.pressed.connect(self._on_host_button_pressed)


func _on_connect_button_pressed():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client($IPInput.text, PORT)
	
	if error:
		print(error)
		return
		
	multiplayer.multiplayer_peer = peer
	print("connected to server")
	get_tree().change_scene_to_file("res://scenes/levels/world.tscn")

func _on_host_button_pressed():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, 8)
	
	if error:
		print(error)
		return
		
	multiplayer.multiplayer_peer = peer
	print("started server")
	get_tree().change_scene_to_file("res://scenes/levels/world.tscn")

