extends GridPosition

class_name EnemyBack

export var shoot_delay = 4
export var move_delay = 3

var move_cooldown = 0
var shoot_cooldown = 0

func _ready():
	TurnManager.connect("enemy_turn", self, "_on_enemy_turn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_enemy_turn():
	# Update cooldowns
	shoot_cooldown -= 1
	move_cooldown -= 1
	
	if move_cooldown < 0:
		try_move(direction)
		move_cooldown = move_delay
	if shoot_cooldown < 0:
		$Shooter.shoot(_grid_position, direction)
		var back_direction = Vector2(0,-direction.y)
		$Shooter.shoot(_grid_position, back_direction)
		shoot_cooldown = shoot_delay


	
	
