extends Node
class_name GameManager

static var item_db: ItemDatabaseComponent = null

func _ready():
	item_db = $ItemDatabaseComponent

	if not multiplayer.is_server():
		return
		
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	for id in multiplayer.get_peers():
		add_player(id)
		
	if not OS.has_feature("dedicated_server"):
		add_player(1)


@rpc("authority", "reliable")
func add_player(id):
	var character = preload("res://scenes/prefabs/entities/player.tscn").instantiate()
	
	character.player = id
	
	character.position = Vector3.ZERO
	
	character.name = str(id)
	$Players.add_child(character, true)
	

@rpc("authority", "reliable")
func remove_player(id):
	if not $Players.has_node(str(id)):
		return
	$Players.get_node(str(id)).queue_free()


# client callable respawn function, checks with the server before respawning a player
@rpc("any_peer", "call_local", "reliable")
func request_respawn():
	var player_id = multiplayer.get_remote_sender_id()
	print("Respawn request for " + str(player_id))
	if multiplayer.is_server() && is_player_dead(player_id):
		print("\t > Request approved.")
		add_player(player_id)


# client callable remove function, checks with the server before removing a player
@rpc("any_peer", "call_local", "reliable")
func request_removal():
	var player_id = multiplayer.get_remote_sender_id()
	print("Remove request for " + str(player_id))
	if multiplayer.is_server():
		print("\t > Request approved.")
		remove_player(player_id)


# utility function for checking if a user is dead
func is_player_dead(id):
	if $Players.get_node_or_null(str(id)) == null:
		return true
	return false
