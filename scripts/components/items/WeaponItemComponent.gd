extends ItemBaseComponent
class_name WeaponItemComponent

enum WEAPON_TYPE {MELEE, RANGED}

@export_group("Weapon Settings")
@export var weapon_type: WEAPON_TYPE
@export var damage: float
@export var bullet_model = ""
@export var ammo_item_id: int = -1
