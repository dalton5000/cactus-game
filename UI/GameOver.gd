extends CanvasLayer

onready var anim_player = $GameOverAnim
onready var music = $Music_GameOver

func _ready():
	anim_player.play("gameover")
	music.play()

func _on_Button_Restart_button_up():
	get_tree().paused = false
	get_tree().reload_current_scene()
