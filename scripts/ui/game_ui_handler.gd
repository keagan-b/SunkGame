extends Control

# variables related to UI pieces
@export var health_status_bar: ColorRect
@export var health_value: Label

@export var oxygen_status_bar: ColorRect
@export var oxygen_value: Label

@export var hunger_status_bar: ColorRect
@export var hunger_value: Label

# UI parent reference
@onready var parent: MasterUIHandler = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# assign UI elements
	if parent.local_player != null:
		# health
		var health_percent = parent.health_component.get_health_as_percent()
		health_value.text = str(int(health_percent * 100)) + "%"
		health_status_bar.scale.x = health_percent
		
		# oxygen
		var oxygen_percent = parent.oxygen_component.get_oxygen_as_percent()
		oxygen_value.text = str(int(oxygen_percent * 100)) + "%"
		oxygen_status_bar.scale.x = oxygen_percent
		
		# hunger
		var hunger_percent = 1
		hunger_value.text = str(int(hunger_percent * 100)) + "%"
		hunger_status_bar.scale.x = hunger_percent



