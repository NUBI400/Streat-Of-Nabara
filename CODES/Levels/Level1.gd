extends Node2D

var enemies_death = 0

@onready var camera = $Camera2D
@onready var ui_canvas = $"UI Canvas"


func enemy_death():
	enemies_death += 1
	match  enemies_death:
		
		04:_next_area(1100.0)
		09:_next_area(1700.0)
		014:_next_area(2164.0)
			
			

func _next_area(limit: float):
	camera.Set_camera_limit(limit)
	ui_canvas.show_go()

func ready():
	$aiai.play()
