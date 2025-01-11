extends CharacterBody2D

#Nós
@onready var sprite = $Sprite
@onready var anim_player = $AnimPlayer
@onready var timer_attack = $Timer_Attack
@onready var delay_attack = $Delay_Attack
@onready var shape = $Shape
@onready var spawn = $Attack/Spawn
@onready var ui_canvas : CanvasLayer = $"../UI Canvas"
@onready var camera = $"../Camera2D"
@onready var timer_energia_voltar = $Timer_energia_voltar


#VIDA
var health = 100
var in_take_damage = false

#Energia
@export var Energia = 50
var energia_can = true
@export var energia_pulo : int = 20
@export var energia_correndo : int = 2
@export var energia_hadouken : int = 30


#Itens
var item = null
var pickuping = false


#Estados
enum{ MOVE, ATTACK, HADOUKEN}
@export var state : int = MOVE
enum{ CHAO, JUMP}
@export var state_jump : int = CHAO
@onready var timer_combo = $TimerCombo


# Movimentação;
var direcao = 1
@export var velocidade_padrao : int = 6000
var velocidade = velocidade_padrao


# Pulo
var MAX_SPEED = 100
var ACCELERATION = 500
var JUMP_SPEED = 25
var GRAVITY = 5
var z = 0
@export var jumpMultiplyer = 8
var Jumping = false


# Animation
var anim = "Idle"


# Corrida
var running = false
var tap_counter = 0 


# Especiais
var sequencia = []
var movimentos = {
	"Hadouken" : ["Baixo","Direita","Attack"],
}
@export var wait_time_combo : float = 0.2
var especial = null

#Attck
const ATTACK_CENE = preload("res://CENAS/Player/player_attack.tscn")
var pode_atacar = true
var attack_index = 0
@export var proximo_atack = true


# Hadouken
@export var hadouken_scene : PackedScene = preload("res://CENAS/Player/hadouken.tscn")
@onready var haddouken_position = $HaddoukenPosition


func _ready():
	ui_canvas.uptate_ui_player(health)
	ui_canvas.uptate_ui_player_energia(Energia)

func _physics_process(delta):
	z_index = global_position.y
	
	match state:
		
		MOVE:
			move(delta)
		
		
		ATTACK:
			attack()
		
		
		HADOUKEN:
			hadouken()
			state = MOVE
	match state_jump:
		
		CHAO:
			pass
		
		
		JUMP:
			jump()
		
		
	
	transform.origin.x = clamp(transform.origin.x, camera.transform.origin.x - 180, camera.clamped + 180)
	
	
	
	move_and_slide()
	set_animation()



func _input(event: InputEvent):
	
	if not event is InputEvent or not event.is_pressed():
		return
	
	if event.is_action_pressed("Esquerda"):
		
		add_input_sequence("Esquerda")
		state = MOVE
		
	if event.is_action_pressed("Direita"):
		
		add_input_sequence("Direita")
		state = MOVE
		
	if event.is_action_pressed("Baixo"):
		
		add_input_sequence("Baixo")
		state = MOVE
		
	if event.is_action_pressed("Cima"):
		
		add_input_sequence("Cima")
		state = MOVE
	
	if Input.is_action_just_pressed("Pulo"):
		state_jump = JUMP
	
	if Input.is_action_just_pressed("to take") and item:
		pickuping = true
		_update_health(item.pickup())
	
	
	if event.is_action_pressed("Attack") and proximo_atack and state_jump == CHAO:
		add_input_sequence("Attack")
		checar_sequencia(sequencia)
		if especial == null:
			state = ATTACK
	
	timer_combo.start(wait_time_combo)


func attack():
	
	if pode_atacar:
		
		timer_attack.start()
		
		attack_index += 1
		if attack_index >= 3:
			pode_atacar = false
		delay_attack.start()
		
		state = MOVE


func set_animation():
	anim = "Idle"
	
	if in_take_damage:
		anim = "hit"
	
	if velocity.x != 0 or velocity.y != 0:
		anim = "Run"
	
	if pickuping:
		sprite.modulate = Color(1,0.122,1)
		await get_tree().create_timer(0.5).timeout
		sprite.modulate = Color(1,1,1)
		pickuping = false 
	
	if Jumping == true:
		anim = "Pulo"
	
	if attack_index >= 1 and attack_index <= 3:
		anim = "Attack_" + str(attack_index)
	
	if especial != null:
		anim = especial
	
	if anim_player.assigned_animation != anim:
		anim_player.play(anim)


func _on_anim_player_animation_finished(anim_name):
	
	if anim_name == "Hadouken":
		especial = null
		state = MOVE

func flip():
	if in_take_damage:
		return
	
	if velocity.x > 0:
		sprite.flip_h = false
		spawn.position.x = 18.8 
		movimentos = {
		"Hadouken" : ["Baixo","Direita","Attack"],
		}


	if velocity.x < 0:
		sprite.flip_h = true
		spawn.position.x = -18.8 
		movimentos = {
		"Hadouken" : ["Baixo","Esquerda","Attack"],
	}


func move(delta : float):
	if in_take_damage:
		return
	direcao = Input.get_vector("Esquerda","Direita","Cima","Baixo")
	velocity = direcao * velocidade * delta
	
	if anim == "Attack_" + str(attack_index) or anim == "Hadouken":
		velocidade = 0
	else:
		if running == false:
			velocidade = velocidade_padrao
	
	_running()
	flip()

func _running():
	if Input.is_action_just_pressed("Direita") or Input.is_action_just_pressed("Esquerda"):
		if not running:
			tap_counter += 1
			await get_tree().create_timer(0.2).timeout
			tap_counter = 0
	elif Input.is_action_pressed("Direita") and Energia >= energia_correndo or Input.is_action_pressed("Esquerda") and Energia >= energia_correndo:
		if not running and tap_counter == 2:
			running = true
			velocidade *= 1.8
			anim_player.speed_scale = 1.2
			
			
	elif Input.is_action_just_released("Direita") or Input.is_action_just_released("Esquerda") or Energia < energia_correndo:
		if running:
			running = false
			velocidade = velocidade_padrao
			anim_player.speed_scale = 1
			timer_energia_voltar.stop()
			await get_tree().create_timer(5).timeout
			timer_energia_voltar.start()
			


	if running and energia_can and Energia >= 2:
		Energia -= energia_correndo
		energia_can = false
		ui_canvas.uptate_ui_player_energia(Energia)
		await get_tree().create_timer(0.2).timeout
		energia_can = true
	
	
	
 
func jump():
	if anim == "Attack_" + str(attack_index) or anim == "Hadouken":
		return
	
	if Input.is_action_just_pressed("Pulo") and Jumping == false and Energia >= energia_pulo:
		Energia -= energia_pulo
		ui_canvas.uptate_ui_player_energia(Energia)
		Jumping = true
		z += -JUMP_SPEED * jumpMultiplyer
		shape.disabled = true
		
		
	if z > 25 * jumpMultiplyer:
		Jumping = false
		state_jump = CHAO
		z = 0
		velocity.y = 0
		shape.disabled = false
		timer_energia_voltar.stop()
		await get_tree().create_timer(5).timeout
		timer_energia_voltar.start()

	
	
		
	if Jumping == true:
		z += GRAVITY
		velocity.y = z


func add_input_sequence(action: String):
	
	sequencia.push_back(action)


func checar_sequencia(sequencia_combo: Array):
	
	for move_name in movimentos.keys():
		
		if sequencia_combo == movimentos[move_name]:
			
			especial = move_name
			
			if especial == "Hadouken" and not Energia >= energia_hadouken:
				especial = null


func hadouken():
	Energia -= energia_hadouken
	ui_canvas.uptate_ui_player_energia(Energia)
	var hadouken_instance = hadouken_scene.instantiate()
	owner.add_child(hadouken_instance)
	
	hadouken_instance.direcao = 1 if sprite.flip_h == false else -1
	hadouken_instance.global_position = haddouken_position.global_position
	
	if sprite.flip_h == false:
		hadouken_instance.rotation_degrees = 0
	if sprite.flip_h == true:
		hadouken_instance.rotation_degrees = 180
		hadouken_instance.sprite.flip_v = true
	
	timer_energia_voltar.stop()
	await get_tree().create_timer(5).timeout
	timer_energia_voltar.start()
	

func _on_timer_attack_timeout():
	attack_index = 0


func _on_delay_attack_timeout():
	pode_atacar = true


func _on_timer_combo_timeout():
	
	checar_sequencia(sequencia)
	
	sequencia = []
	


func player_attack(damage_index: int, damage: int) -> void:
	checar_sequencia(sequencia)
	if especial == null:
		var attk = ATTACK_CENE.instantiate()
		attk.index = damage_index
		attk.strong = damage
		get_parent().add_child(attk)
		attk.transform.origin = get_node("Attack/Spawn").global_transform.origin

func _stop_movement():
	velocidade = 0
	velocity.x = 0
	velocity.y = 0


func _restart_movement():
	anim_player.play("Run")
	velocidade = velocidade_padrao
	#take_damage_entry = false


func take_damage(value: int):
	health = max(0,health - value)
	ui_canvas.uptate_ui_player(health)
	if health <= 0:
		_death()
	else:
		in_take_damage = true
		_stop_movement()
		await get_tree().create_timer(1).timeout 
		in_take_damage = false

func _update_health(value : int):
	health = min(health + value, 100)
	Energia = min(Energia + value, 50)
	ui_canvas.uptate_ui_player(health)
	ui_canvas.uptate_ui_player_energia(Energia)

func _estamina_voltar():
	if Energia < ui_canvas.Energia.max_value and not running:
		Energia += 1
		timer_energia_voltar.start()
	ui_canvas.uptate_ui_player_energia(Energia)
	

func _death():
	get_tree().change_scene_to_file("res://CENAS/Mapas/TV.tscn")



func _on_timer_energia_voltar_timeout():
	_estamina_voltar() 
