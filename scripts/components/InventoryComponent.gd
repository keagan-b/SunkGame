extends Node
class_name InventoryComponent

# variables
@export var rows = 5
@export var columns = 5

# inventory
@export var inventory = [];
var remaining_space = rows * columns

# functions
func _ready():
	for i in rows:
		inventory.append([])
		for j in columns:
			inventory[i].append([-1, 0])


# attempt to find an item in the inventory. if successful, returns
# the row/column, and quantity of all instances. if not successful, 
# returns null.
func find_item(id: int):
	var found = []
	for i in rows:
		for j in columns:
			if inventory[i][j][0] == id:
				found.append([i, j, inventory[i][j][1]])
	
	# return null if there are no results
	if found == []:
		return null
	else:
		return found


# find the first empty slot in the inventory
func get_empty():
	if remaining_space == 0:
		return null
	
	var empty = [-1, -1]
	for i in rows:
			for j in columns:
				if inventory[i][j][0] == -1:
					empty[0] = i
					empty[1] = j
					return empty


# adds an item to the inventory
func add_item(id: int, quantity: int = 1):
	var found = find_item(id)
	var max_stack = GameManager.item_db.get_item(id).max_stack
	
	# check all found and see if we can insert
	if found != null:
		
		# loop through all found slots
		for f in found:
			# if the slot isn't at max stack, add to it
			if f[2] != max_stack:
				# if we can fit the entire quantity in this slot, do so
				if max_stack - f[2] >= quantity:
					f[2] += quantity
					quantity = 0
				# otherwise add however much we can, and continue the loop
				else:
					quantity -= max_stack - f[2]
					f[2] = max_stack
	
	# if we have items left after attempting to stack, add to empty slots
	if quantity != 0:
		# check if inventory has space
		var empty = get_empty()
		while empty != null && quantity > 0:
			# update remaining space
			remaining_space -= 1
			
			# add item to this slot
			if quantity > max_stack:
				inventory[empty[0]][empty[1]] = [id, max_stack]
				quantity -= max_stack
				
				# attempt to find new empty slot 
				empty = get_empty()
			else:
				inventory[empty[0]][empty[1]] = [id, quantity]
				quantity = 0
	
	# return the remaining quantity to add
	return quantity


func remove_item(id: int, quantity: int = 1):
	
	# check if there are enough items to remove
	if !has_items(id, quantity):
		return quantity
	
	# get list of all items
	var found = find_item(id)
	
	if found != null:
		for f in found:
			# check if there are too few items in this slot
			if inventory[f[0]][f[1]][1] - quantity <= 0:
				# reduce  quantity left to remove
				quantity -= inventory[f[0]][f[1]][1]
				
				# mark slot as empty
				inventory[f[0]][f[1]][0] = -1
				inventory[f[0]][f[1]][1] = 0
				remaining_space += 1
			else:
				# remove remaining quantity from slot
				inventory[f[0]][f[1]][1] -= quantity
			
	# return remaining quantity to be removed
	return quantity



func has_items(id: int, quantity: int = 1):
	# try to find items
	var found = find_item(id)
	
	if found == null:
		return false
	else:
		var total = 0
		# loop through found slots
		for f in found:
			# add found quantity to total
			total += f[2]
			
			# check if we can quit the loop
			if total >= quantity:
				break
				
		if total >= quantity:
			# found quantity of items
			return true
		else:
			# could not find quantity of items
			return false


func transfer_item(slot, new_inventory: InventoryComponent):
	pass


