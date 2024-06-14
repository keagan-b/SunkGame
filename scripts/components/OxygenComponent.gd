extends Node
class_name OxygenComponent

# variables
@export var max_oxygen: float = 100
@export var current_oxygen: float = 0

# signals
signal lost_oxygen(old, new)
signal gained_oxygen(old, new)
signal out_of_oxygen()


# functionality
func _ready():
	initialize_oxygen()

@rpc("authority", "reliable")
func add_oxygen(amount):
	var old_oxygen = current_oxygen
	
	current_oxygen += amount
	
	if current_oxygen > max_oxygen:
		current_oxygen = max_oxygen
		
	gained_oxygen.emit(old_oxygen, current_oxygen)
	
@rpc("authority", "reliable")
func remove_oxygen(amount):
	
	var old_oxygen = current_oxygen
	
	current_oxygen -= amount
	
	lost_oxygen.emit(old_oxygen, current_oxygen)
	
	if current_oxygen <= 0:
		out_of_oxygen.emit()
		current_oxygen = 0
		

@rpc("authority", "reliable")
func initialize_oxygen():
	current_oxygen = max_oxygen


func get_oxygen_as_percent():
	return (1.0 / max_oxygen) * current_oxygen
