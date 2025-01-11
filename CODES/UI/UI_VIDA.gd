extends Control

@onready var helth_bar = $helth_bar
@onready var timer = $Timer


func _ready():
	helth_bar.value = helth_bar.max_value
	helth_bar.hide()

func uptate_ui_enemy(value : int):
	helth_bar.show()
	timer.stop()
	timer.start()
	var tween = get_tree().create_tween()
	tween.tween_property(helth_bar, "value", value, 1).set_trans(Tween.TRANS_ELASTIC)
	tween.play()



func _on_timer_timeout():
	helth_bar.hide()
