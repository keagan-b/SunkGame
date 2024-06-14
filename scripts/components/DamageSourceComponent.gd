extends Area3D
class_name DamageComponent


# public variables
@export var damage = 10
@export var apply_over_time = false
@export var destroy_on_damage = true
@export var damage_on_collision = true

# functions

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", _on_body_entered)


func _on_body_entered(body: Node3D):
	if damage_on_collision:
		var health_component = body.get_node_or_null("HealthComponent")
		
		if health_component != null:
			health_component.take_damage_from_source(self)
			
			if destroy_on_damage:
				queue_free()
	
