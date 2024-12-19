extends CharacterBody2D

@export var speed = 70 # Adjust this value to your desired speed
@onready var anim = $AnimationPlayer

var isAttacking = false
var current_direction = "idle"

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	
	if not isAttacking:
		if Input.is_action_pressed("left"):
			velocity.x -= 1
			
		if Input.is_action_pressed("right"):
			velocity.x += 1
		
		if Input.is_action_pressed("up"):
			velocity.y -= 1
			
		if Input.is_action_pressed("down"):
			velocity.y += 1
		
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
			anim.play("down_attack") # Optional: Idle attack animation if needed
	
	# Set a timer to reset isAttacking after the attack animation finishes
	var attack_duration = anim.current_animation_length
	$attack_cooldown.start(attack_duration)

func _on_attack_cooldown_timeout() -> void:
	isAttacking = false
