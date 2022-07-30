extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speedX = 10.0;
export var speedXJumping = 3.0;
export var jumpForce = 400.0;
export(Texture) var emptyHeart
var sprite
var AnimationP
var rayCast
export var GravityGoingUp = 10.0;
export var GravityGoingDown = 30.0;

var heartArray = []

var isJumping = false;

var goingRight = true;

var speedY = 0.0;

var invulnerable = false

var lives = 3

var blinking = false
var blinkTime = 0.0
export var blinkDuration = 0.05

var invulnerabilityTime = 0.0
export var invulnerabilityDuration = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = get_node("Sprite")
	heartArray.append(get_node("../CanvasLayer/Control/Heart1"))
	heartArray.append(get_node("../CanvasLayer/Control/Heart2"))
	heartArray.append(get_node("../CanvasLayer/Control/Heart3"))
	AnimationP = get_node("AnimationPlayer")
	rayCast = get_node("RayCast2D")
	pass # Replace with function body.


func _process(delta):
	if blinking:
		blinkTime += delta
		if blinkTime >= blinkDuration:
			sprite.visible = !sprite.visible
			blinkTime = 0.0
	if invulnerable:
		invulnerabilityTime += delta
		if invulnerabilityTime  >= invulnerabilityDuration:
			invulnerable = false
			blinking = false
			sprite.visible = true

func _physics_process(delta):
	
	if rayCast.is_colliding():
		isJumping = false;
	else:
		isJumping = true;
	
	var movement = Vector2(0.0, 0.0)
	if Input.is_action_pressed("Left"):
		if not isJumping:
			movement.x -= speedX * delta;
		else:
			movement.x -= speedXJumping * delta;
	elif Input.is_action_pressed("Right"):
		if not isJumping:
			movement.x += speedX * delta;
		else:
			movement.x += speedXJumping * delta;
	if Input.is_action_just_pressed("Jump") and not isJumping:
		speedY -= jumpForce;
		if goingRight:
			AnimationP.play("Jump_Right");
		else:
			AnimationP.play("Jump_Left");
	
	if speedY >= 0.0:
		speedY += GravityGoingDown;
	else:
		speedY += GravityGoingUp;
	
	movement.y = speedY;

	movement = move_and_slide(movement)
	
	speedY = movement.y
	
	if not isJumping:
		if movement.y == 0:
			if movement.x > 0:
				AnimationP.play("Run_Right")
				goingRight = true;
			elif movement.x < 0:
				AnimationP.play("Run_Left")
				goingRight = false;
			elif rayCast.is_colliding():
				AnimationP.play("Idle")
		else:
			if goingRight:
				AnimationP.play("Fall_Right");
			else:
				AnimationP.play("Fall_Left");
	
			
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.has_meta("type"):
			if collision.collider.get_meta("type") == "Enemy":
				if not invulnerable:
					invulnerable = true
					blinking = true
					blinkTime = 0.0
					invulnerabilityTime = 0.0
					lives -= 1
					if lives < 0:
						get_tree().change_scene("res://scenes/GameOver.tscn")
					else:
						heartArray[lives].set_texture(emptyHeart)
					

