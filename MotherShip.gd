extends GridPosition

signal mothership_killed

var turn_to_load = 8
var loading_turn = 0
onready var bullet = preload("res://Bullet.tscn")

func _ready():
	TurnManager.connect("player_turn", self, "on_player_turn")

func _process(delta):
	if Input.is_action_just_pressed("ctrl") and loading_turn >= turn_to_load:
		loading_turn = 0
		$Shooter.shoot(_grid_position, Vector2(0, 1), bullet)
		$Shooter.shoot(_grid_position, Vector2(0, -1), bullet)
		$Shooter.shoot(_grid_position, Vector2(1, 0), bullet)
		$Shooter.shoot(_grid_position, Vector2(-1, 0), bullet)
		$"../LabelMother".text = "Turns until fortress loaded: " + str(turn_to_load-loading_turn)

func on_player_turn():
	loading_turn = min(loading_turn + 1, turn_to_load)
	if loading_turn >= turn_to_load:
		$"../LabelMother".text = "Fortress loaded - PRESS CTRL"
	else:
		$"../LabelMother".text = "Fortress loaded in " + str(turn_to_load-loading_turn) + " turns"

func _exit_tree():
	emit_signal("mothership_killed")

