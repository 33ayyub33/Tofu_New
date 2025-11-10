extends Control

func _ready():
	Global.stop_music()

func _on_home_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_kembali_pressed():
	get_tree().change_scene_to_file("res://piilih_game.tscn")


func _on_retry_pressed():
	get_tree().change_scene_to_file("res://game_1.tscn")
