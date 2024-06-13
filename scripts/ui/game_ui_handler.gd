extends Control

# variables related to UI pieces
@export var health_status_bar: ColorRect
@export var health_value: Label

@export var oxygen_status_bar: ColorRect
@export var oxygen_value: Label

@export var hunger_status_bar: ColorRect
@export var hunger_value: Label

# global "players" holder
@onready var players: Node3D = owner.get_node("Players")

# variables related to local player health
@onready var player: CharacterBody3D = null
@onready var health_component: HealthComponent = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# attempt to find player
	if player == null:
		set_local_player()
		
	# assign UI elements
	if player != null:
		health_value.text = str(health_component.get_health_as_percent()) + "%"


func set_local_player():
	# get player
	player = players.get_node_or_null(str(multiplayer.get_unique_id()))
	
	# get individual components if the player was found
	if player != null:
		health_component = player.get_node("HealthComponent")