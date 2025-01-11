extends Area2D

var strong := 10

func _on_timer_timeout():
	queue_free()


func _on_attack_body_entered(body: Node):
	body.take_damage(strong)
