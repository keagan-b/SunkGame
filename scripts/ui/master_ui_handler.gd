extends Control
class_name MasterUIHandler

# global "players" holder
@onready var PLAYERS: Node3D = owner.get_node("Players")

# local player references
@export var local_player: CharacterBody3D = null:
	get:
		if local_player == null:
			# find local player
			local_player = PLAYERS.get_node_or_null(str(multiplayer.get_unique_id()))
			
			# get local components if player was found
			if local_player != null:
				health_component = local_player.get_node("HealthComponent")
				oxygen_component = local_player.get_node("OxygenComponent")
		
		return local_player

@onready var health_component: HealthComponent = null
@onready var oxygen_component: OxygenComponent = null


# local UI references
@onready var game_ui: Control = $GameUI
@onready var pause_menu: Control = $PauseMenu
@onready var inventory: Control = $Inventory
@onready var crafting: Control = $Crafting
@onready var map: Control = $Map
@onready var spawn_menu: Control = $SpawnMenu
@onready var options: Control = $Options


# order-keeping variables
var events_connected = false

func _process(_delta):
	# check to ensure events have been connected
	if !events_connected && local_player != null:
		# connect events
		local_player.get_node("HealthComponent").connect("has_died", _has_died)
		
		# mark events as connected
		events_connected = true


# player death event handling
func _has_died():
	# hide all other UI
	hide_all_ui()
	
	# unlock mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# show spawn menu
	spawn_menu.show()

func respawn():
	# hide all UI
	hide_all_ui()

	# activate game ui
	game_ui.show()
	
	# reset event connections
	events_connected = false


# utility function to hide all UI
func hide_all_ui():
	game_ui.hide()
	pause_menu.hide()
	inventory.hide()
	crafting.hide()
	map.hide()
	spawn_menu.hide()
	options.hide()
