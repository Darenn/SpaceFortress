extends GridPosition

class_name NME_kamikaze

export var is_vertical_attacker = true

var stop_move = false
var bullet = null

func _ready():
	pass
#	TurnManager.connect("enemy_turn", self, "_on_enemy_turn")

func _on_enemy_turn():
	_update_rotation(direction)
	
	var o_bullet = Grid.contains_node_of_group(_grid_position, "Bullets")
	if o_bullet != null and !o_bullet.is_in_group("NMEBullets"):
		destroy()
		o_bullet.destroy();
	
	var middle_y = floor(Grid.GRID_SIZE.y/2)
	var middle_x = floor(Grid.GRID_SIZE.x/2)
	
	if not stop_move and not captured:
		if is_vertical_attacker:
			direction.x = 0
			if _grid_position.y < middle_y:
				direction.y = 1
			elif _grid_position.y > middle_y:
				direction.y = -1
			else:
				direction.y = 0
				if _grid_position.x > middle_x :
					direction.x = -1
				else:
					direction.x = 1
		else:
			direction.y = 0
			if _grid_position.x < middle_x :
				direction.x = 1
			elif _grid_position.x > middle_x :
				direction.x = -1
			else:
				direction.x = 0
				if _grid_position.y > middle_y:
					direction.y = -1
				else:
					direction.y = 1
		if not Grid.contains_node_of_group(_grid_position + direction, "Bullets"):
			if not Grid.contains_node_of_group(_grid_position + direction, "Enemies"):				
				try_move(direction)
				yield(tween, "tween_completed")
				var mothership = Grid.contains_node_of_group(_grid_position, "MotherShip")
				if mothership:
					mothership.destroy()
				emit_signal("turn_completed")
		return true
	return true