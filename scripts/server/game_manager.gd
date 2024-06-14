extends Node
class_name GameManager

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
	var character = preload("res://scenes/prefabs/entities/player.tscn").instantiate()
	
	character.player = id
	
	character.position = Vector3.ZERO
	
	character.name = str(id)
	$Players.add_child(character, true)
	

func remove_player(id):
	if not $Players.has_node(str(id)):
		return
	$Players.get_node(str(id)).queue_free()


# client callable respawn function, checks with the server before respawning a player
@rpc("any_peer", "reliable")
func request_respawn():
	var player_id = multiplayer.get_remote_sender_id()
	if multiplayer.is_server() && is_player_dead(player_id):
		print("Respawn request for " + str(player_id))
		add_player(player_id)


# utility function for checking if a user is dead
func is_player_dead(id):
	if $Players.get_node_or_null(str(id)) == null:
		return true
	else:
		return false

