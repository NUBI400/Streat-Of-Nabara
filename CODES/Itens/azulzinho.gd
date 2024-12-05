extends Area2D

var vida = 100




func _on_body_entered(body):
	if body.name.match("Adamastor"):
		body.item = self
		print(body)


func _on_body_exited(body):
	if body.name.match("Adamastor"):
		body.item = null

func pickup():
	queue_free()
	return vida
