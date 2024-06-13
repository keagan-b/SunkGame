extends Node
class_name HealthComponent

# variables
@export var max_health: float = 100
@export var current_health: float = 0

# signals
signal damage_taken(old, new, source)
signal has_died


# functionality
func _ready():
	initialize_health()

@rpc("authority", "reliable")
func take_damage(damage_source: DamageComponent):
	var old_health = current_health
	current_health -= damage_source.damage
	
	damage_taken.emit(old_health, current_health, damage_source)
	
	if current_health <= 0:
		has_died.emit()

@rpc("authority", "reliable")
func heal(amount):
	# heal by amount
	current_health += amount
	
	# check if the healed amount is more than max health
	if current_health > max_health:
		current_health = max_health
	

@rpc("authority", "reliable")
func set_max_health(health):
	max_health = health


@rpc("authority", "reliable")
func initialize_health():
	current_health = max_health


func get_health_as_percent():
	return (1.0 / max_health) * current_health
