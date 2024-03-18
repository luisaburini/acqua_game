extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var target_position = Vector2()
var clicked_position = Vector2()
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
signal limite_direito
signal limite_esquerdo
var screen_size
var troca_cenario = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if position.distance_to(clicked_position) > 3:
		target_position = (clicked_position - position).normalized()
		velocity = target_position * SPEED
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
		$AnimatedSprite2D.play()
		move_and_slide()
	
func start(pos):
	position = pos
	show()

func _process(delta):
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

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			var local_event = make_input_local(event)
			clicked_position = event.position
			
func _ready():
	screen_size = get_viewport_rect().size
