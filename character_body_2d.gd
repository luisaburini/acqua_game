extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = 100.0
var target_position = position
var clicked_position = position
signal limite_direito
signal limite_esquerdo
var walking = false
var started = false

func _physics_process(delta):
	if started:
		if position.distance_to(clicked_position) > 2:
			target_position = (clicked_position - position).normalized()
			velocity = target_position * SPEED
			$AnimatedSprite2D.animation = "walk"
			$AnimatedSprite2D.flip_h = velocity.x > 0
			walking = true
			$AnimatedSprite2D.flip_v = false
			$AnimatedSprite2D.play()
			move_and_slide()
			for i in get_slide_collision_count():
				walk_to(position)
		else:
			walking = false
			$AnimatedSprite2D.animation = "idle"
			$AnimatedSprite2D.play()

		show()
	
func start(pos):
	started = true 
	go_to(pos)
	$AnimatedSprite2D.animation = "idle"
	$AnimatedSprite2D.flip_h = false
	$AnimatedSprite2D.play()
	show()
			
func end():
	started = false
	hide()
			
func _ready():
	pass

func _on_main_reset_pos_direito(pos):
	go_to(pos)

func _on_main_reset_pos_esquerdo(pos):
	go_to(pos)

func is_walking():
	return walking

func walk_to(pos):
	clicked_position.x = pos.x
	clicked_position.y = pos.y

func go_to(pos):
	target_position.x = pos.x
	target_position.y = pos.y
	
	clicked_position.x = pos.x
	clicked_position.y = pos.y
	
	position.x = pos.x 
	position.y = pos.y
	
	velocity = Vector2(0,0)
	walking = false		
	
func flip_horizontal(shouldFlip):
	$AnimatedSprite2D.flip_h = shouldFlip
