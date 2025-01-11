extends CanvasLayer

@onready var player_health = $UIGamePlay/HUDPlayer/Health
@onready var Energia = $UIGamePlay/HUDPlayer/Energia

func _ready():
	player_health.value = player_health.max_value
	Energia.value = Energia.max_value
	$Go.hide()

func uptate_ui_player(value : int):
	var tween = get_tree().create_tween()
	tween.tween_property(player_health, "value", value, 1).set_trans(Tween.TRANS_ELASTIC)
	tween.play()

func uptate_ui_player_energia(value : int):
	var tween = get_tree().create_tween()
	tween.tween_property(Energia, "value", value, 0.5).set_trans(Tween.TRANS_EXPO)
	tween.play()

func show_go():
	$AnimationPlayer.play("go")
