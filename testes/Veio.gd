extends CharacterBody2D

@export var velocidade = 80
@onready var adamastor = $"../Adamastor"

####MAQUINAS DE ESTADOS#####
const NO_CHAO = 1
const NO_AR = 2
const CAINDO = 3
var estado_pulo = NO_CHAO
const PARADO = 4
const ANDANDO = 5
const CORRENDO = 6
const ROLANDO = 7 
var estado_movimento = PARADO
#var estado_atacando = ATACANDO
const EM_PE = 8
const AGACHADO = 9
var estado_personagem = EM_PE
const ATACANDO = 10
var estado_atk = ATACANDO
######

func _ready():
	pass

func _physics_process(delta: float) -> void:
	animate()
	

func _process(delta):
	
	
	#var direcao = Input.get_vector("esquerda","direita","cima","baixo")
	#
	#if Global.podesemexer == false : direcao = Vector2.ZERO
	#
	#if Input.is_action_just_pressed("esquerda") and Input.is_action_just_pressed("direita"):
		#Global.podesemexer = false
	
	#velocity = direcao * velocidade 
	
	
	
########MAQUINA DE ESTADO DO PULO#######
	#if estado_pulo == NO_CHAO:
		#no_chao()
	#elif estado_pulo == NO_AR:
		#pulando()
	#elif estado_pulo == CAINDO:
		#caindo()


#######MAQUINA DE ESTADO DE MOVIMENTO#######
	if estado_movimento == PARADO:
		funcao_parado()
	elif estado_movimento == ANDANDO:
		funcao_andando()
	elif estado_movimento == CORRENDO:
		funcao_correndo()

########MAQUINA DE ESTADO DE PERSONAGEM######
	#if estado_personagem == EM_PE:
		#func_empe()
	#elif estado_personagem == AGACHADO:
		#funcao_agachado()
#########
	
	
	move_and_slide()
	print(estado_movimento)

func animate() -> void:
	
	if velocity.x > 0:
		$sprite.flip_h = false
		$CollisionShape2D.position.x = 1.5
	if velocity.x < 0:
		$sprite.flip_h = true
		$CollisionShape2D.position.x = -2.5

func funcao_parado():
	
	
	if (velocity == Vector2.ZERO):
		$AnimationPlayer.play("idle")
	
	
#######ANIMACAO PARADO DEPOIS DE PULAR#####
	#if estado_pulo == NO_CHAO and estado_personagem == EM_PE and is_on_floor():
		#$AnimationPlayer.play("correndo")
##########


#####ANDAR & CORRER ANIMATION######
	if velocity.x != 0 or velocity.y != 0 && estado_pulo == NO_CHAO and estado_personagem == EM_PE:
		estado_movimento = ANDANDO
		$AnimationPlayer.play("andando")
		
	if velocity.x != 0 or velocity.y != 0 && Input.is_action_just_pressed("correr") && estado_pulo == NO_CHAO and estado_personagem == EM_PE:
		estado_movimento = CORRENDO
		$AnimationPlayer.play("correndo")
######

func funcao_andando():
	
####FICAR PARADO####
	if velocity.x == 0 and velocity.y == 0 and estado_pulo == NO_CHAO and estado_personagem == EM_PE:
		estado_movimento = PARADO

######


####CORRER####
	if Input.is_action_pressed("correr") && estado_pulo == NO_CHAO and estado_personagem == EM_PE:
		estado_movimento = CORRENDO
		$AnimationPlayer.play("correndo")
####

func funcao_correndo():
####AUMENTAR A VELOCIDADE PARA CORRER####
	velocity *= 2
#####

####FICAR PARADO####
	if velocity.x == 0 and velocity.y == 0 and estado_pulo == NO_CHAO and estado_personagem == EM_PE:
		estado_movimento = PARADO
####

####IR DE CORRENDO PARA PARADO####
	if not Input.is_action_pressed("correr") && estado_pulo == NO_CHAO:
		estado_movimento = ANDANDO
		$AnimationPlayer.play("andando")
####
