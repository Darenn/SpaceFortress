extends GridPosition

class_name Bullet

# Called when the node enters the scene tree for the first time.
#func _ready():
# warning-ignore:return_value_discarded
#	TurnManager.connect("bullet_turn", self, "_on_bullet_turn")

func _ready():
	$Sound.stream = preload("res://Laser_Shoot5.wav")
	$Sound.play()

# warning-ignore:unused_argument
func _process(delta):
	pass
	
func _on_bullet_turn():
	if Grid.can_move(_grid_position + direction):
		var otherBullet = Grid.contains_node_of_group(_grid_position + direction, "Bullets")
		if otherBullet:
			try_move(direction.normalized().round())
			yield(tween, "tween_completed")
			destroy()
			otherBullet.destroy()
			emit_signal("turn_completed")
			return false
		var otherEnemy = Grid.contains_node_of_group(_grid_position + direction, "Enemies")
		if otherEnemy:
			try_move(direction.normalized().round())
			yield(tween, "tween_completed")
			destroy()
			otherEnemy.destroy()
			emit_signal("turn_completed")
			return false
		var otherPlayer = Grid.contains_node_of_group(_grid_position + direction, "MotherShip")
		if otherPlayer:
			try_move(direction.normalized().round())
			yield(tween, "tween_completed")
			destroy()
			otherPlayer.destroy()
			emit_signal("turn_completed")
			return false
		try_move(direction.normalized().round())
		yield(tween, "tween_completed")
		emit_signal("turn_completed")
	else: 	
		tween_to_world(Grid.get_world_position(_grid_position) + direction*3*Grid.CELL_SIZE)
		yield(tween, "tween_completed")
		destroy()
		emit_signal("turn_completed")
	return true
	

func _set_direction(new_direction):
	direction = new_direction
	if direction.x > 0:
		rotation = PI/2
	elif direction.x < 0:
		rotation = -PI/2
	elif direction.y > 0:
		rotation = PI
	elif direction.y < 0:
		rotation = 0