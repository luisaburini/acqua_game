extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = 100.0
var target_position = position
var clicked_position = position
signal limite_direito
signal limite_esquerdo
signal user_clicked(position)

var screen_size
var troca_cenario = true
var walking = false

func _physics_process(delta):
	walking = false
	if position.distance_to(clicked_position) > 2:
		target_position = (clicked_position - position).normalized()
		velocity = target_position * SPEED
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
		$AnimatedSprite2D.play()
		walking = true
		move_and_slide()
	for i in get_slide_collision_count():
		clicked_position.x = position.x
		clicked_position.y = position.y
		
	
func start(pos):
	target_position = pos
	clicked_position = pos
	show()
			
			
func _ready():
	screen_size = get_viewport_rect().size


func _on_sebo_user_can_go_to(pos):
	if not walking:
		clicked_position = pos


func _on_main_reset_pos_direito(pos):
	print("Reset pos direito")
	walking = false
	position.x = pos.x
	position.y = pos.y


func _on_main_reset_pos_esquerdo(pos):
	print("Reset pos esquerdo")
	walking = false
	position.x = pos.x
	position.y = pos.y

func is_walking():
	return walking


func _on_praca_user_can_go_to(pos):
	if not walking:
		clicked_position = pos
