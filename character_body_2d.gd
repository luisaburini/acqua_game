extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = 100.0
var target_position = position
var clicked_position = position
signal limite_direito
signal limite_esquerdo

var screen_size
var troca_cenario = true
var walking = false

func _physics_process(delta):
	walking = false
	if position.distance_to(clicked_position) > 2:
		target_position = (clicked_position - position).normalized()
		velocity = target_position * SPEED
		if velocity.length() == 0:
			$AnimatedSprite2D.animation = "idle"
		else:
			$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
		$AnimatedSprite2D.play()
		walking = true
		move_and_slide()
	for i in get_slide_collision_count():
		walk_to_position(position)
		
	
func start(pos):
	go_to_position(pos)
	show()
			
			
func _ready():
	screen_size = get_viewport_rect().size


func _on_main_reset_pos_direito(pos):
	go_to_position(pos)


func _on_main_reset_pos_esquerdo(pos):
	go_to_position(pos)

func is_walking():
	return walking

func walk_to_position(pos):
	clicked_position = pos

func go_to_position(pos):
	walking = false
	position = pos
	target_position = pos
	clicked_position = pos
	
