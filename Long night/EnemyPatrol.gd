extends KinematicBody2D

export var amount = 5
var initialPos
var goingRight = true
export var speed = 500.0
var KillCollision
var player
var particleSystem
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var animationPlayer
var sprite
var CollisionPhyisics
var killcollisionCollider

var dead = false
var deadTimerBool = false
var deadTimer = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	set_meta("type", "Enemy")
	player = get_node("../Player")
	sprite = get_node("Enemy1")
	CollisionPhyisics = get_node("CollisionShape2D")
	KillCollision = get_node("Enemy1/Area2D")
	killcollisionCollider = get_node("Enemy1/Area2D/KissCollision")
	initialPos = position.x
	animationPlayer = get_node("Enemy1/AnimationPlayer")
	particleSystem = get_node("Particles2D")
	pass # Replace with function body.

func _process(delta):
	if dead and not deadTimerBool:
		deadTimerBool = true
		sprite.visible = false
		CollisionPhyisics.disabled = true
		killcollisionCollider.disabled = true
	if deadTimerBool:
		deadTimer += delta
		if deadTimer >= 1.0:
			queue_free()

func _physics_process(delta):
	if goingRight:
		animationPlayer.play("WalkRight")
		move_and_slide(Vector2(speed*delta, 0))
	else:
		animationPlayer.play("WalkLeft")
		move_and_slide(Vector2(-speed*delta, 0))
	if goingRight and position.x > initialPos + amount:
		goingRight = false
	elif not goingRight and position.x < initialPos - amount:
		goingRight = true

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	if area.get_parent() == player:
		set_meta("type", "DeadEnemy")
		dead = true
		particleSystem.restart()
	pass # Replace with function body.
