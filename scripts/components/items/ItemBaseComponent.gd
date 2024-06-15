extends Node
class_name ItemBaseComponent

# variables relating to the item
@export_group("Basic Item Info")
@export var item_name: String = ""
@export_multiline var item_desc: String = ""
@export var max_stack: int = 1

@export_group("Appearance Settings")
@export var ground_mesh: Mesh = null
@export_file("*.png") var item_icon: String = ""

@export_subgroup("Holding Appearance")
@export var is_holdable: bool = false
@export var holdable_model: Mesh = null
