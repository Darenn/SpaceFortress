extends Node2D

const CELL_SIZE = Vector2(32, 32)
const GRID_SIZE = Vector2(9, 9)
const OFFSET = 1

var grid = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(Grid.GRID_SIZE.x):
		for y in range(Grid.GRID_SIZE.y):
			var cell = preload("res://Cell.tscn") # Will load when the script is instanced.
			var node = cell.instance()
			add_child(node)
			node.position = Vector2((x + Grid.OFFSET)*Grid.CELL_SIZE.x + Grid.CELL_SIZE.x/2, (y+Grid.OFFSET)*Grid.CELL_SIZE.y + Grid.CELL_SIZE.y/2)
			Grid.grid[Vector2(x, y)] = [node]
			
#func _process(delta):
#	for x in range(GRID_SIZE.x):
#		for y in range(GRID_SIZE.y):		
#			grid[Vector2(x, y)][0].get_node("Label").text = ""
#			for node in grid[Vector2(x, y)]:
#				if is_instance_valid(node):
#					grid[Vector2(x, y)][0].get_node("Label").text += node.name + "\n"
			
func can_move(grid_position):
	if grid_position.x >= 0 and grid_position.x < GRID_SIZE.x and grid_position.y >= 0 and grid_position.y < GRID_SIZE.y:
		return true
	else:
		return false
	
func get_world_position(grid_position):
	return Vector2((grid_position.x + OFFSET)*CELL_SIZE.x + CELL_SIZE.x/2, 
			(grid_position.y+OFFSET)*CELL_SIZE.y + CELL_SIZE.y/2)
			
func contains_node_of_group(grid_position, group):
	for node in grid[grid_position]:
		if not is_instance_valid(node):
			continue
		if node.is_in_group(group):
			return node;
	return null
