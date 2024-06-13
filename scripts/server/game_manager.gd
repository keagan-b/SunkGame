extends Node

func _ready():
	if not multiplayer.is_server():
		return
		
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	for id in multiplayer.get_peers():
		add_player(id)
		
	if not OS.has_feature("dedicated_server"):
		add_player(1)
		

func add_player(id):
	var character = preload("res://scenes/prefabs/player.tscn").instantiate()
	
	character.player = id
	
	character.position = Vector3.ZERO
	
	character.name = str(id)
	$Players.add_child(character, true)
	
func remove_player(id):
	if not $Players.has_node(str(id)):
		return
	$Players.get_node(str(id)).queue_free()
