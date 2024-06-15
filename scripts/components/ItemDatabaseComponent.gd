extends Node
class_name ItemDatabaseComponent

@export var item_database: Array[ItemBaseComponent] = []


# return an ItemBaseComponent, if it exists, from the database
func get_item(id) -> ItemBaseComponent:
	# ensure item is valid in database
	if id >= len(item_database) || id < 0:
		return null
	else:
		return item_database[id]
