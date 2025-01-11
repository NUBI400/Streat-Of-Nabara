extends CharacterBody2D
 
# Pulo
var MAX_SPEED = 100
var ACCELERATION = 500
var JUMP_SPEED = 25
var GRAVITY = 5
@onready var sprite = $Sprite
@onready var shape = $Shape

 # Movimentação;
var direcao = 1
@export var velocidade_padrao : int = 6000
var velocidade = velocidade_padrao

var z = 0
 
var jumpMultiplyer = 8
 
var Jumping = false
 
func _physics_process(delta):
	var axis = move(delta)
	
	jump()
	move_and_slide()

	
 
func jump():
	
	if Input.is_action_just_pressed("Pulo") and Jumping == false:
#		$AnimationPlayer.play("Jump")
		Jumping = true
		z += -JUMP_SPEED * jumpMultiplyer
		shape.disabled = true
		
	if z > 25 * jumpMultiplyer:
		Jumping = false
		z = 0
		velocity.y = 0
		shape.disabled = false
		
		
	if Jumping == true:
		z += GRAVITY
		velocity.y = z


func flip():
	
	if velocity.x > 0:
		sprite.flip_h = false


	if velocity.x < 0:
		sprite.flip_h = true

func move(delta : float):
	
	direcao = Input.get_vector("Esquerda","Direita","Cima","Baixo")
	velocity = direcao * velocidade * delta
	
	
	flip()
	
