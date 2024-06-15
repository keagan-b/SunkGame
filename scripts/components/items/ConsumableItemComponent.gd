extends ItemBaseComponent
class_name ConsumableItemComponent

enum ATTRIBUTES {HEALTH, OXYGEN, HUNGER}

@export_group("Consumable Settings")
@export var support_attribute: ATTRIBUTES
@export var increase_value: float

func consume():
	pass
