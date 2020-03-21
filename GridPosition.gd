extends Node2D

class_name GridPosition

signal turn_completed

export var _grid_position = Vector2(0, 0)
export var direction = Vector2(0, -1)
export var has_direction = true
export var speed = 0.5

onready var explosion = preload("res://Explosion.tscn")

var captured = false

onready var tween = $Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	try_move_to(_grid_position)
	_update_rotation(direction);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func try_move(grid_movement):
	if Grid.can_move(_grid_position + grid_movement):
		tween_to(_grid_position + grid_movement)
		Grid.grid[_grid_position].erase(self)
		_grid_position = _grid_position + grid_movement
		Grid.grid[_grid_position].append(self)
		_update_rotation(grid_movement)
		return true
	return false
	
func try_move_to(to_grid_position):
	if Grid.can_move(to_grid_position):
		Grid.grid[_grid_position].erase(self)
		_grid_position = to_grid_position
		position = Grid.get_world_position(_grid_position)
		Grid.grid[to_grid_position].append(self)
		return true
	return false
	

func tween_to(to):
	if not is_instance_valid(tween): return
	tween.interpolate_property(self, "position",
    Grid.get_world_position(_grid_position), Grid.get_world_position(to), speed,
    Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	if $Engine != null:
		$Engine.show()
	tween.start()
	yield(tween, "tween_completed")
	if $Engine != null:
		$Engine.hide()

func tween_to_world(to):
	if not is_instance_valid(tween): return
	tween.interpolate_property(self, "position",
    position, to, speed,
    Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _update_rotation(new_direction):
	direction = new_direction
	if direction.x > 0:
		rotation = PI/2
	elif direction.x < 0:
		rotation = -PI/2
	elif direction.y > 0:
		rotation = PI
	elif direction.y < 0:
		rotation = 0

func destroy():
	Grid.grid[_grid_position].erase(self)
	var node = explosion.instance()
	get_tree().get_current_scene().add_child(node)
	node.position = position
	# i should detroy the node but... well.
	queue_free()