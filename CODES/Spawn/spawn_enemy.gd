extends Area2D

@export var enemy_amount = 0
const ENEMIES = [
	preload("res://CENAS/Enemys/Velho2.tscn")
]
func _ready():
	randomize()
func _on_spawn_enemy_body_entered(body):
	_spawn_enemies(enemy_amount)
func _spawn_enemies(amount : int):
	for i in amount:
		var enemy = ENEMIES[randi() % ENEMIES.size()].instantiate()
		enemy.transform.origin = _set_enemy_random_position()
		get_parent().add_child(enemy)
	queue_free()
func _set_enemy_random_position():
	var side = randi() % 2
	var new_position = Vector2()
	match side:
		0: new_position = Vector2(get_parent().get_node("Camera2D").transform.origin.x -250, randf_range(275,366))
		1: new_position = Vector2(get_parent().get_node("Camera2D").transform.origin.x + 250, randf_range(275,366))
	return new_position
