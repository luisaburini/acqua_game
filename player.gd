extends Area2D

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var delta_x = 0
var delta_y = 0
var target_position = Vector2()
var clicked_position = Vector2()
var troca_cenario = true
signal limite_direito
signal limite_esquerdo

func _physics_process(delta):
	if Input.is_action_just_pressed("pressed"):
		clicked_position = get_global_mouse_position()
	var velocity = Vector2.ZERO # The player's movement vector
	if position.distance_to(clicked_position) > 3:
		target_position = (clicked_position - position).normalized()
		velocity = target_position * speed
		$CharacterBody2D.move_and_slide()
# Called when the node enters the scene tree for the first time.
func _ready():
	target_position = position
	screen_size = get_viewport_rect().size

func start(pos):
	position = pos
	show()
	monitoring = true

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if String(event.as_text()).contains("Screen touched"):
			print(event.as_text())
			delta_x = position.x - event.position.x
			delta_y = position.y - event.position.y
			target_position = event.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	var velocity = Vector2.ZERO # The player's movement vector.
	velocity.x += delta_x
	velocity.y += delta_y
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		velocity = Vector2.ZERO 
		$AnimatedSprite2D.stop()
		delta_x = 0
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x > 0
	elif velocity.y > 0:
		$AnimatedSprite2D.animation = "down"
		$AnimatedSprite2D.flip_v = false
	elif velocity.y < 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = false
		
	position += velocity * delta
	if delta_x < 1 and delta_x > -1:
		print("position.x ", position.x)
		position.x += sign(delta_x)*1
		print("position.x ", position.x)
		delta_x += sign(delta_y)*1
	if delta_y < 1 and delta_y > -1:
		print("position.y ", position.y)
		position.y = position.y + sign(delta_y)*1
		print("position.y ", position.y)
		delta_y += sign(delta_y)*1
		
	var clamp_position = position.clamp(Vector2.ZERO, screen_size)
	if clamp_position == position:
		troca_cenario = true
	if clamp_position.x > position.x and clamp_position.y == position.y:
		if troca_cenario:
			limite_esquerdo.emit()
		position.x = screen_size.x
		troca_cenario = false
	elif clamp_position.x < position.x and clamp_position.y == position.y:
		if troca_cenario:
			limite_direito.emit()
		position.x = 100
		troca_cenario = false
	position.y = clamp_position.y
