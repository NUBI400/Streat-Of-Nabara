extends RichTextLabel
 
var s = 0
var m = 3
var funciona = true
func _process(delta):
	
	if m >= 1 and s == 0:
		m -= 1
		s += 59
	
	if m == 0 and s == 0 and funciona == true and $"..".visible == true:
		$Timer.stop()
		$tempoacabou.start()
		funciona = false
		$"../UIGamePlay/Cabou".visible = true
		print(" aa")
	
	
	set_text(str(m)+":"+str(s))
	
	
	
func _on_timer_timeout():
	s -= 1
	
	



func _on_tempoacabou_timeout():
	get_tree().change_scene_to_file("res://CENAS/Mapas/TV.tscn")
