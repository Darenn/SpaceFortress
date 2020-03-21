extends GridPosition

class_name EnemyDualR

export var is_vertical_attacker = true

var stop_move = true

var shoot_delay = 2
var shoot_timer = 0

onready var bullet = preload("res://NMEBullet.tscn") 

var middle_y = floor(Grid.GRID_SIZE.y/2)
var middle_x = floor(Grid.GRID_SIZE.x/2)

func _ready():
	
	var o_bullet = Grid.contains_node_of_group(_grid_position, "Bullets")
	if o_bullet != null and !o_bullet.is_in_group("NMEBullets"):
		destroy()
		o_bullet.destroy();
	
	if is_vertical_attacker:
		direction.x = 0
		if _grid_position.y < middle_y:
			direction.y = 1
		elif _grid_position.y > middle_y:
			direction.y = -1
	else:
		direction.y = 0
		if _grid_position.x < middle_x :
			direction.x = 1
		elif _grid_position.x > middle_x :
			direction.x = -1
	_update_rotation(direction)
	$Sprite.animation = "filled"
#	TurnManager.connect("enemy_turn", self, "_on_enemy_turn")

func _on_enemy_turn():
	_update_rotation(direction)
	
	if shoot_timer == 2:
		$Sprite.animation = "filled"
	shoot_timer -= 1
	
	if shoot_timer <= 0:
		$Sprite.animation = "empty"
		shoot_timer = shoot_delay
		$Shooter.shoot(_grid_position, direction, bullet)
		var right_direction = Vector2(0,0)
		if direction.y == -1:
			right_direction.x = 1
		else:
			right_direction.x = -1
		$Shooter.shoot(_grid_position, right_direction, bullet)
		return true
	
	if not stop_move and not captured:
		if is_vertical_attacker:
			direction.x = 0
			if _grid_position.y < middle_y:
				direction.y = 1
			elif _grid_position.y > middle_y:
				direction.y = -1
			else:
				stop_move = true
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
				stop_move = true
				direction.x = 0
				if _grid_position.y > middle_y:
					direction.y = -1
				else:
					direction.y = 1
		if not Grid.contains_node_of_group(_grid_position + direction, "Bullets"):
			if not Grid.contains_node_of_group(_grid_position + direction, "Enemies"):
				if not stop_move:				
					try_move(direction)
					yield(tween, "tween_completed")
				var mothership = Grid.contains_node_of_group(_grid_position, "MotherShip")
				if mothership:
					mothership.destroy()
				emit_signal("turn_completed")
		
	_update_rotation(direction)
	return true


	
	
