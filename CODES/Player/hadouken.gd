extends Area2D

@onready var sprite = $Sprite
@export var velocidade : int = 92
var direcao = 1

var index  := 1
var strong := 30

func _ready():
	pass

func _physics_process(delta):
	z_index = global_position.y
	
	global_position.x += direcao * velocidade * delta

func _on_visibility_screen_exited():
	queue_free()


func _on_attack_body_entered(body: Node):
	body.take_damage(index, strong)
