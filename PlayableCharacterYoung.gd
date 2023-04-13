extends CharacterBody2D

var speed = 100
var screen_size
var elapsed: float

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.animation = "waking"
	$AnimatedSprite2D.play()
	await get_tree().create_timer(2.9).timeout
	$AnimatedSprite2D.animation = "left"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsed += delta
	
	if elapsed > 2.9:
		@warning_ignore("shadowed_variable_base_class")
		var velocity = Vector2.ZERO
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_just_pressed("roll"):
			velocity = velocity * 2
			await get_tree().create_timer(3).timeout
		
		move_and_collide(Vector2(0, 0))
		
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			$AnimatedSprite2D.play()
		else:
			$AnimatedSprite2D.stop()
		position += velocity * delta
		position.x = clamp(position.x, 0, screen_size.x)
		position.y = clamp(position.y, 0, screen_size.y)
		
		if velocity.x > 0:
			$AnimatedSprite2D.animation = "right"
		elif velocity.x < 0:
			$AnimatedSprite2D.animation = "left"
