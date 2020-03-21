extends Node2D

var k = preload("res://NME_kamikaze.tscn")
var std = preload("res://Enemy.tscn")
var dual_r = preload("res://EnemyDualR.tscn")
var dual_l = preload("res://EnemyDualL.tscn")
var e_db = preload("res://EnemyBack.tscn")
var multi = preload("res://EnemyAllSide.tscn")

var vortex = preload("res://Vortex.tscn")

export var vortexSpeed = 1
export var vortexClosedSpeed = 0.2
export var spawnSpeed = 0.5

var waves = []

class Spawnable:
	var NME;
	var pos_x;
	var pos_y;
	var is_vertical_attacker;
	
	func _init(_NME, _pos_x, _pos_y):
		NME = _NME
		pos_x = _pos_x
		pos_y = _pos_y
		if _pos_y == 0 or _pos_y == 8:
			is_vertical_attacker = true
		else:
			is_vertical_attacker = false

func _spawn(enemy, grid_position_x, grid_position_y, vertical_attacker = true):
	# Crate the vortex
	var vort = vortex.instance()
	vort.scale = Vector2(0,0)
	add_child(vort)
	vort.position = Grid.get_world_position(Vector2(grid_position_x, grid_position_y))
	$Tween.interpolate_property(vort, "scale",
    Vector2(0, 0), Vector2(1, 1), 1,
    Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	
	# Create the NME
	var node = enemy.instance()
	node.scale = Vector2(0,0)
	add_child(node)	
	node.try_move_to(Vector2(grid_position_x, grid_position_y))
	node.is_vertical_attacker = vertical_attacker
	$Tween.interpolate_property(node, "scale",
    Vector2(0, 0), Vector2(1, 1), spawnSpeed,
    Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	
	# Close the vortex
	$Tween.interpolate_property(vort, "scale",
    Vector2(1, 1), Vector2(0, 0), vortexClosedSpeed,
    Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	vort.queue_free()

var WarningCell = preload("res://WarningCell.tscn") # Will load when the script is instanced.

func _on_enemy_turn():
	for NME in waves[TurnManager.turn]:
		_spawn(NME.NME, NME.pos_x, NME.pos_y, NME.is_vertical_attacker)
		yield(get_tree().create_timer(1), "timeout")
	for NME in waves[TurnManager.turn + 1]:
		_spawn_warning_zone(NME, 1)
		yield(get_tree().create_timer(0.5), "timeout")
	for NME in waves[TurnManager.turn + 2]:
		_spawn_warning_zone(NME, 2)
		yield(get_tree().create_timer(0.5), "timeout")
		
func _spawn_warning_zone(NME, turn):
	var node = WarningCell.instance()
	node.get_node("Label").text = str(turn)
	add_child(node)
	node.position= Vector2(Grid.CELL_SIZE.x + NME.pos_x* Grid.CELL_SIZE.x + Grid.CELL_SIZE.x/2, Grid.CELL_SIZE.y + NME.pos_y* Grid.CELL_SIZE.y + Grid.CELL_SIZE.y/2)
	TurnManager.connect("enemy_turn", node, "_on_enemy_turn")

func _ready():
	TurnManager.connect("enemy_turn", self, "_on_enemy_turn")
	for i in range(100):
		waves.append([])

	var top = 0
	var bot = 8
	var left = 0
	var right = 8
		
	## spawn guidelines
#	- avoid spawn in corners (0, 0), (0, 8), (8, 0), (8, 8) because of the NME behaviour
#	- avoid spawn in the middles at 4

	
	waves[2] = [
			Spawnable.new(k, 1, top),
	]

	waves[3] = [
			Spawnable.new(k, 2, bot),
	]

	waves[4] = [
			Spawnable.new(k, left, 3),
	]

	waves[5] = [
			Spawnable.new(k, right, 3),
	]
	
	waves[6] = [
			Spawnable.new(k, 7, bot),
	]
	
	waves[7] = [
			Spawnable.new(k, 1, top),
	]
	
	waves[8] = [
			Spawnable.new(k, right, 3),
	]
	
	waves[9] = [
			Spawnable.new(std, left, 2),
	]
	
	waves[10] = [
			Spawnable.new(k, right, 2),
	]
	
	waves[11] = [
			Spawnable.new(k, 3, top),
	]
	
	waves[12] = [
			Spawnable.new(std,7, bot),
	]
	
	waves[13] = [
			Spawnable.new(k,left, 2),
	]
	
	waves[14] = [
			Spawnable.new(std,2, top),
	]
	
	waves[15] = [
			Spawnable.new(k,right, 2),
	]
	
	waves[16] = [
			Spawnable.new(k,2, bot),
	]
	
	waves[17] = [
			Spawnable.new(std,2, top),
	]
	
	waves[18] = [
			Spawnable.new(std,7, bot),
	]
	
	waves[19] = [
			Spawnable.new(dual_l,7, bot - 1),
	]
	
	waves[20] = [
			Spawnable.new(k,left, 3),
	]
	
	waves[21] = [
			Spawnable.new(k,right, 7),
	]
	
	waves[22] = [
			Spawnable.new(std,7, top),
	]
	
	waves[23] = [
			Spawnable.new(dual_r,6, top - 2),
	]
	
	waves[24] = [
			Spawnable.new(dual_l,2, top - 3),
	]
	
	waves[25] = [
			Spawnable.new(k,2, bot),
			Spawnable.new(k,7, bot),
	]
	
	waves[26] = [
			Spawnable.new(k,right, 3),
	]
	
	waves[27] = [
			Spawnable.new(k,3, top),
	]
	
	waves[28] = [
			Spawnable.new(multi,5, bot - 3),
	]
	
	waves[29] = [
			Spawnable.new(k,7, top),
			Spawnable.new(k,left, 3),
	]
	
	waves[30] = [
			Spawnable.new(k,2, top),
	]
	
	waves[31] = [
			Spawnable.new(std,right, 7),
	]
	
	waves[32] = [
			Spawnable.new(std,left, 2),
	]
	
	waves[33] = [
			Spawnable.new(dual_l,2, bot - 3),
	]
	
	waves[34] = [
			Spawnable.new(dual_l,7, top + 3),
	]
	
	waves[35] = [
			Spawnable.new(k,2, bot),
			Spawnable.new(k,right, 7),
	]
	
	waves[36] = [
			Spawnable.new(std,left, 2),
	]
	
	waves[37] = [
			Spawnable.new(multi,3, top + 5),
	]
	
	waves[38] = [
			Spawnable.new(k,5, top),
			Spawnable.new(k,left, 2),
	]
	
	waves[39] = [
			Spawnable.new(std,left, 7),
	]
	
	waves[40] = [
			Spawnable.new(k,1, bot),
			Spawnable.new(k,2, bot),
			Spawnable.new(k,3, bot),
			Spawnable.new(k,left, 2),
	]
	
	waves[41] = [
			Spawnable.new(std,right, 2),
			Spawnable.new(std,right, 3),
	]
	
	
	
	
