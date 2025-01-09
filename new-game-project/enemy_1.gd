extends CharacterBody2D

@export var health = 30
@export var speed = 15
var player_chase = false
var player: Node2D = null
@onready var anim = $AnimationPlayer
@onready var coin = preload("res://coin.tscn")
@onready var hurtbox = $Sprite2D/Area2D

func _physics_process(delta):
	if player_chase and player != null:
		# Calculate direction to the player
		var direction = (player.position - position).normalized()

		position += direction * speed * delta

		play_animation_based_on_direction(direction)

func play_animation_based_on_direction(direction: Vector2):
	# Determine movement direction
	if direction.x > 0:  # Moving right
		anim.play("right")
		hurtbox.scale.x = 1
	elif direction.x < 0:  # Moving left
		anim.play("left")
		hurtbox.scale.x = -1

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body
		player_chase = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		player_chase = false

func take_damage():
	var opposite = (player.position - position).normalized()
	position -= opposite * speed

	health -= 10
	if health <= 0:
		spawn_coin()
		queue_free()

func spawn_coin():
	var coin_instance = coin.instantiate()
	coin_instance.position = position  # Set coin position to the enemy's position
	get_parent().add_child(coin_instance)

func _on_area_2d_2_area_entered(area: Area2D) -> void:
	if area.is_in_group("hurtbox"):
		take_damage()
