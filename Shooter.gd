extends Node2D

class_name Shooter

func _ready():
	pass # Replace with function body.

func shoot(grid_position, direction, bullet):
	if Grid.can_move(grid_position + direction):
		var otherBullet = Grid.contains_node_of_group(grid_position + direction, "Bullets")
		if otherBullet:
			otherBullet.destroy()
			return
		var otherEnemy = Grid.contains_node_of_group(grid_position + direction, "Enemies")
		if otherEnemy:
			otherEnemy.destroy()
			return
		var otherPlayer = Grid.contains_node_of_group(grid_position + direction, "Player")
		if otherPlayer:
			return		
		var node = bullet.instance()
		get_tree().get_current_scene().add_child(node)
		node.direction = direction
		node._update_rotation(direction)
		node.try_move_to(grid_position)
		if not node.try_move(direction):
			node.destroy()
