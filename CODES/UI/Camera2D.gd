extends Camera2D

var smooth = 4
var clamped = 550.0


@onready var player : CharacterBody2D = get_parent().get_node("Adamastor")


func _process(delta):
	if transform.origin.x < player.transform.origin.x:
		position.x = lerp(position.x, player.transform.origin.x, smooth * delta)
	
	position.x = clamp(position.x,0,clamped)

func Set_camera_limit(limit : float):
	clamped = limit
