extends CharacterBody2D

@export var health = 100
@export var speed = 100
var player_chase = false
var player: Node2D = null
@onready var anim = $AnimationPlayer

func _physics_process(delta):
	if player_chase and player != null:
		position += (player.position - position) / speed
	else:
		anim.play("idle")

func _on_area_2d_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		player_chase = false
