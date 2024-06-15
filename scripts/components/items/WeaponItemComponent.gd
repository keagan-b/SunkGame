extends ItemBaseComponent
class_name WeaponItemComponent

enum WEAPON_TYPE {RANGED, MELEE}

@export_group("Weapon Settings")
@export var damage: float
@export var bullet_model = ""
@export var ammo_item_id: int = -1
