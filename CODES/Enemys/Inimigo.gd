extends CharacterBody2D 

const GRAVITY := 9.8

@export var speed_default : int = 50 
@export var health_default : int = 100
@export var cooldown_attack : int = 1.0

var knockback = Vector2()
var death = false 
var on_hit = false
var walk_timer = 0.0
var x_direction = 0.0  
var y_direction = 0.0
var knockback_speed = 0.2
var take_damage_index = 0

var animation = " "
var facing_right = false 
var take_damage_entry = false
var in_attack = false
var can_attack = true
const ATTACK_CENE = preload("res://CENAS/Enemys/enemy_attack.tscn")

@onready var speed = speed_default 
@onready var health = health_default
@onready var sprite = $Sprite
@onready var anim_player = $AnimPlayer
@onready var player : CharacterBody2D = get_parent().get_node("Adamastor")
@onready var take_damage_timer = $Take_Damage_Timer
@onready var spawn = $Attack/Spawn
@onready var ui_vida = $UI_VIDA

func _ready(): 
	randomize() 

func _process(delta: float): 
	
	_movement(delta)
	_animations()
	_flip()

func _physics_process(delta : float):
	z_index = global_position.y
	if death and on_hit or on_hit:
		_knockback()
	move_and_slide()

func _movement(delta):
	if take_damage_entry:
		return
		
	if not death and not in_attack:
		var target_distance = player.transform.origin - transform.origin
		x_direction = target_distance.x / abs(target_distance.x)  
		
		walk_timer += delta 
		if walk_timer > randi_range(1, 2):
			y_direction = randi() % 3 -1 
			walk_timer = 0 

		if abs(target_distance.x) < 60:
			x_direction = 0

		if abs(target_distance.x) < 60 and abs(target_distance.y) < 10 and not in_attack and can_attack:
			in_attack = true
			can_attack = false
			_stop_movement()
			await get_tree().create_timer(0.5).timeout
			in_attack = false
			await get_tree().create_timer(cooldown_attack).timeout
			can_attack = true
			speed = speed_default
		velocity = Vector2(x_direction, y_direction) * speed 


func take_damage(damage_index: int,damage: int):
	if death:
		return
	
	take_damage_timer.stop()
	take_damage_index = damage_index
	take_damage_entry = true
	_stop_movement()
	
	anim_player.play("damage_%s" % take_damage_index)
	
	if take_damage_index >=3:
		on_hit = true
		take_damage_timer.start()
		set_collision_layer_value(3, false)
	
	health = max(0,health - damage)
	ui_vida.uptate_ui_enemy(health)
	if health <= 0:
		_death()
	else:
		take_damage_timer.start()

func _knockback():
	var direction = global_transform.origin.x - player.global_transform.origin.x
	knockback.x = direction * knockback_speed / 6
	knockback.y = knockback_speed * -1
	set_velocity(knockback)
	set_up_direction(Vector2.UP)
	move_and_slide()
	knockback = velocity
	
	
	await get_tree().create_timer(0.3).timeout
	on_hit = false
	
func _animations():
	if take_damage_entry:
		return
	
	if in_attack:
		_set_animation("Attack_1")
	else:
		if velocity:
			_set_animation("Run")
		else:
			_set_animation("Idle")


func _flip():
	if take_damage_entry or in_attack:
		return
	facing_right = true if player.transform.origin.x > transform.origin.x else false
	if facing_right:
		sprite.flip_h = false
		spawn.position.x = 18.8 
	else:
		sprite.flip_h = true
		spawn.position.x = -18.8 
		
func _set_animation(anim: String):
	if animation != anim:
		animation = anim
		anim_player.play(animation)


func _death():
	death = true
	on_hit = true
	anim_player.play("damage_3")
	set_collision_layer_value(2, false)
	await get_tree().create_timer(0.7).timeout
	
	for _i in range(10):
		sprite.visible = not sprite.visible
		await get_tree().create_timer(0.1).timeout
	get_parent().enemy_death()
	queue_free()



func _stop_movement():
	speed = 0
	velocity.x = 0
	velocity.y = 0


func _restart_movement():
	anim_player.play("Run")
	speed = speed_default
	take_damage_entry = false


func _on_take_damage_timer_timeout():
	if take_damage_index >= 3:
		await get_tree().create_timer(1).timeout
		anim_player.play("up")
		await get_tree().create_timer(1).timeout
		anim_player.play("Idle")
		set_collision_layer_value(3, true)
		_restart_movement()
	else:
		_restart_movement()

func enemy_attack(value: int):
	var attk = ATTACK_CENE.instantiate()
	attk.strong = value
	get_parent().add_child(attk)
	attk.transform.origin = get_node("Attack/Spawn").global_transform.origin
