extends Node2D

signal player_turn
signal bullet_turn
signal enemy_turn

signal enemy_turn_start
signal bullet_turn_start

var turn = 1

		
func on_player_turn_end():
	emit_signal("enemy_turn_start")
	for NME in get_tree().get_nodes_in_group("Enemies"):
		if is_instance_valid(NME):
			NME._on_enemy_turn()
			yield(get_tree().create_timer(0.3), "timeout")
	emit_signal("enemy_turn")
	yield(get_tree().create_timer(1.5), "timeout")
	emit_signal("bullet_turn_start")
	for bullet in get_tree().get_nodes_in_group("Bullets"):
		if is_instance_valid(bullet):
			bullet._on_bullet_turn()
			yield(get_tree().create_timer(0.1), "timeout")	
	emit_signal("bullet_turn")
	yield(get_tree().create_timer(1.0), "timeout")
	turn += 1
	emit_signal("player_turn")
