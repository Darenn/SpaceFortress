extends TextureRect

var game_started = false
var game_over = false

var turn_to_win = 43

func _ready():
	$End.text = ""
	$Sound.stream = preload("res://Sounds/ryanAprilJams.wav")
	$Sound.play()
	$TurnBack.modulate = Color(0, 0, 0, 0)
	TurnManager.connect("bullet_turn_start", self, "on_bullet_turn_start")
	TurnManager.connect("enemy_turn_start", self, "on_enemy_turn_start")
	TurnManager.connect("player_turn", self, "on_player_turn_start")
	$Player.connect("player_is_dead", self, "_on_player_killed")
	$MotherShip.connect("mothership_killed", self, "_on_fortress_killed")
	$LabelMother.text = ""
	
	
func _process(delta):
	if(turn_to_win == TurnManager.turn):
		on_win()
	$Label.text = str(turn_to_win - TurnManager.turn)
	if Input.is_action_just_pressed("ui_accept") and not game_started:
		game_started = true
		$Intro.text = ""
		$Start.text = ""
		TurnManager.emit_signal("enemy_turn")
		TurnManager.emit_signal("player_turn")
	if Input.is_action_just_pressed("ui_accept") and game_over:
		TurnManager.turn = 1
		get_tree().reload_current_scene()
		
func on_win():
	$End.text = "You win"
	$Intro.text = "You defended the fortress"
	$Start.text = "Press Enter to retry"
	$Music.stream = preload("res://Victory1.wav")
	$Music.play()
	game_over = true
		
func _on_player_killed():
	$End.text = "Game Over"
	$Intro.text = "You were killed"
	$Start.text = "Press Enter to retry"
	$Music.stream = preload("res://Raining Bits.ogg")
	$Music.play()
	game_over = true
	
	
func _on_fortress_killed():
	$Music.stream = preload("res://Raining Bits.ogg")
	$Music.play()
	$End.text = "Game Over"
	$Intro.text = "The fortress was destroyed"
	$Start.text = "Press Enter to retry"
	game_over = true
	
func on_bullet_turn_start():
	pass
#	$Who.text = "World Turn"
#	$Who.modulate = Color(1, 1, 0)
#	$TurnBack.modulate = Color(1, 1, 0, 0.1)
	
func on_enemy_turn_start():
	$Who.text = "Enemy Turn"
	$Sound.stream = preload("res://Powerup7.wav")
	$Sound.play()
	$Who.modulate = Color(1, 0, 0)
	$Actions.modulate = Color(1, 0, 0)
	$TurnBack.modulate = Color(1, 0, 0, 0.1)
	
func on_player_turn_start():
	$Sound.stream = preload("res://Blip_Select14.wav")
	$Sound.play()
	$Actions.modulate = Color(1, 1, 1)
	$Who.text = "Player Turn"
	$Who.modulate = Color(0, 1, 0)
	$TurnBack.modulate = Color(0, 0, 0, 0)