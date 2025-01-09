extends Node2D

@onready var enemy = preload("res://enemy_1.tscn")
@onready var spawn1 = $spawn_1.position
@onready var spawn2 = $spawn_2.position
@onready var spawn3 = $spawn_3.position
@onready var spawn4 = $spawn_4.position
@onready var tickspeed = $Timer
var maxenemy = 1
var checkcap = 0
var wave = 1
var shop_phase = false

func _ready():
	# Start the timer as soon as the scene is ready
	tickspeed.start()

func _input(event):
	if event.is_action_pressed("quit_game"):
		get_tree().quit()

func _process(delta):
	#if get_tree().get_nodes_in_group("enemy").size() == 0:
	#	$Timer.start()
	pass

func _on_timer_timeout() -> void:
	if checkcap != maxenemy and shop_phase == false:
		# Spawn an enemy at a random position
		var random_spawn = randi_range(1, 4)
		var enemy_spawn = enemy.instantiate()

		match random_spawn:
			1:
				enemy_spawn.position = spawn1
			2:
				enemy_spawn.position = spawn2
			3:
				enemy_spawn.position = spawn3
			4:
				enemy_spawn.position = spawn4

		get_parent().add_child(enemy_spawn)
		checkcap += 1
	elif get_tree().get_nodes_in_group("enemy").size() == 0:
		checkcap = 0
		maxenemy += 1
		wave += 1
		$player/wave.text = "Wave: " + str(wave)
