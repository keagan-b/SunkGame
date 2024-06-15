extends Node3D

@export var item_id: int = -1
@export var stack_size: int = 1

var item: ItemBaseComponent = null

@onready var mesh_instance: MeshInstance3D = $ItemMesh

var try_update: bool = false

func set_item(id):
	if id != -1:
		item_id = id
		item = GameManager.item_db.get_item(id)
		
		mesh_instance.mesh = item.ground_mesh


# check if there is a preset item id for this dropped item
func _ready():
	if item_id != -1:
		try_update = true
	
	$Area3D.connect("body_entered", _temp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	print(try_update)
	if try_update:
		if item_id != -1:
			set_item(item_id)
			try_update = false

func _temp(body: Node3D):
	var inventory_component: InventoryComponent = body.get_node_or_null("InventoryComponent")
		
	if inventory_component != null:
		stack_size = inventory_component.add_item(item_id, stack_size)
			
		if stack_size == 0:
			queue_free()
	
