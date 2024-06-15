extends ItemBaseComponent
class_name ArmorItemComponent

enum ARMOR_LOCATION {HEAD, CHEST, HANDS, LEGS, FEET}

@export_group("Armor Settings")
@export var slot: ARMOR_LOCATION
@export var damage_reductoin: float
