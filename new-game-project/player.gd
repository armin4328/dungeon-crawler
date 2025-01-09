extends CharacterBody2D

@export var health = 30
@export var coins = 0
@export var speed = 70
@onready var anim = $AnimationPlayer
@onready var coinLabel = $Camera2D/Panel/Label
@onready var hearts = $Camera2D/AnimatedSprite2D

var isAttacking = false
var current_direction = "idle"
var last_direction = "idle"

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO

	coinLabel.text = ": " + str(Global.coins)

	if not isAttacking:
		if Input.is_action_pressed("left"):
			current_direction = "left"
			velocity.x -= 1
			$Sprite2D/Area2D.rotation = 0
			$Sprite2D/Area2D.scale.x = 1
			last_direction = "left"

		if Input.is_action_pressed("right"):
			current_direction = "right"
			velocity.x += 1
			$Sprite2D/Area2D.rotation = 0
			$Sprite2D/Area2D.scale.x = -1
			last_direction = "right"

		if Input.is_action_pressed("up"):
			current_direction = "up"
			velocity.y -= 1
			$Sprite2D/Area2D.scale.x = 1
			$Sprite2D/Area2D.rotation = -80
			last_direction = "up"

		if Input.is_action_pressed("down"):
			current_direction = "down"
			$Sprite2D/Area2D.scale.x = 1
			velocity.y += 1
			$Sprite2D/Area2D.rotation = 80
			last_direction = "down"

		# Normalize the velocity to ensure consistent speed in all directions
		if velocity != Vector2.ZERO:
			velocity = velocity.normalized() * speed

			# Determine movement direction for animations
			if abs(velocity.x) > abs(velocity.y):
				if velocity.x > 0:
					current_direction = "right"
				else:
					current_direction = "left"
			else:
				if velocity.y > 0:
					current_direction = "down"
				else:
					current_direction = "up"
		else:
			current_direction = "idle"

		# Play movement animations based on direction
		anim.play(current_direction if current_direction != "idle" else "idle")
	else:
		# Ensure the attack animation is playing when attacking
		anim.play(current_direction + "_attack")

	move_and_slide()

func _input(event):
	if event.is_action_pressed("attack") and not isAttacking:
		isAttacking = true
		play_attack_animation()

func play_attack_animation():
	match current_direction:
		"up":
			anim.play("up_attack")
		"down":
			anim.play("down_attack")
		"left":
			anim.play("left_attack")
		"right":
			anim.play("right_attack")
		"idle":
			anim.play(last_direction + "_attack") # Optional: Idle attack animation if needed

	# Set a timer to reset isAttacking after the attack animation finishes
	var attack_duration = anim.current_animation_length
	$attack_cooldown.start(attack_duration)

func _on_attack_cooldown_timeout() -> void:
	isAttacking = false
	current_direction = "idle"
	anim.play(last_direction if last_direction != "idle" else "idle")

func update_health():
	if health >= 30:
		hearts.play("healthy")
	elif health >= 20:
		hearts.play("injured")
	elif health >= 10:
		hearts.play("fatal")
	elif health <= 0:
		hearts.play("dead")
		queue_free()
		get_tree().change_scene_to_file("res://menu.tscn")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_hurtbox"):
		health -= 10
		update_health()
