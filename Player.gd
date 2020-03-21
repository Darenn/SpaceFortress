extends GridPosition

class_name Player

signal player_is_dead

export var max_actions = 3


var NME_captured = null

onready var bullet = preload("res://Bullet.tscn")
onready var move_sound = preload("res://move.wav")

var is_player_turn = false
var number_actions_made = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	TurnManager.connect("player_turn", self, "_on_player_turn")
	speed = 0.1

func _process(delta):
	var has_played = false
	if is_player_turn:
		if not is_instance_valid(NME_captured): NME_captured = null
		check_for_NME()
		var move = Vector2(0, 0)
		if Input.is_action_just_pressed("ui_right"):
			if direction.x == 1: move += Vector2(1, 0)
			else: direction = Vector2(1, 0)
		if Input.is_action_just_pressed("ui_left"):
			if direction.x == -1: move += Vector2(-1, 0)
			else: direction = Vector2(-1, 0)
		if Input.is_action_just_pressed("ui_up"):
			if direction.y == -1: move += Vector2(0, -1)
			else: direction = Vector2(0, -1)
		if Input.is_action_just_pressed("ui_down"):
			if direction.y == 1: move += Vector2(0, 1)
			else: direction = Vector2(0, 1)
		var oBullet = null
		if Grid.can_move(_grid_position + direction):
			 oBullet = Grid.contains_node_of_group(_grid_position + direction, "NMEBullets")
		if move != Vector2(0, 0) and !oBullet and try_move(move):
			$Sound.stream = move_sound
			$Sound.play()
			if NME_captured:
				NME_captured.try_move(move)
			check_for_NME()
			has_played = true
		# First bug : you can press space and a direction to move and then shoot
		if Input.is_action_just_pressed("ui_select"):
			var otherBullet = Grid.contains_node_of_group(_grid_position + direction, "Bullets")
			if otherBullet and otherBullet.is_in_group("NMEBullets"): otherBullet = null
			if not otherBullet:
				 # Will load when the script is instanced
				$Shooter.shoot(_grid_position, direction, bullet)
#				if NME_captured:
#					if NME_captured is EnemyDual:
#						$Shooter.shoot(_grid_position, direction, bullet)
#						var right_direction = Vector2(0,0)
#						if direction.y == -1:
#							right_direction.x = 1
#						else:
#							right_direction.x = -1
#						$Shooter.shoot(_grid_position, right_direction, bullet)
#					elif NME_captured is EnemyBack:
#						$Shooter.shoot(_grid_position, direction, bullet)
#						var back_direction = Vector2(0,-direction.y)
#						$Shooter.shoot(_grid_position, back_direction, bullet)
#					elif NME_captured is EnemyAllSide:
#						$Shooter.shoot(_grid_position, Vector2(0, 1), bullet)
#						$Shooter.shoot(_grid_position, Vector2(0, -1), bullet)
#						$Shooter.shoot(_grid_position, Vector2(1, 0), bullet)
#						$Shooter.shoot(_grid_position, Vector2(-1, 0), bullet)
#					elif NME_captured is Enemy:
#						$Shooter.shoot(_grid_position, direction, bullet)
#					elif NME_captured is NME_kamikaze:
#						pass
#				else:
#					$Shooter.shoot(_grid_position, direction, bullet)
				has_played = true
		_update_rotation(direction);
	if has_played:
		number_actions_made += 1
		$"../Actions".text = str(max_actions - number_actions_made)
		if number_actions_made >= max_actions:
			number_actions_made = 0
			$"../Actions".text = str(max_actions - number_actions_made)
			is_player_turn = false
			TurnManager.on_player_turn_end()
		
func _on_player_turn():
	is_player_turn = true
	
func check_for_NME():
	var otherNME = Grid.contains_node_of_group(_grid_position, "Enemies")
	if otherNME:
		otherNME.captured = true
		if NME_captured and NME_captured != otherNME:
			NME_captured.destroy()
		NME_captured = otherNME;
		NME_captured.bullet = bullet
	
func destroy():
	.destroy()
	emit_signal("player_is_dead")
