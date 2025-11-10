extends Control


func _ready():
	Global.stop_music()

func _on_kembali_pressed():
	get_tree().change_scene_to_file("res://2_game_2_pilih_SOAL.tscn")


func _on_home_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")
	


func _on_retry_pressed():
	get_tree().change_scene_to_file("res://game_2_soal_3.tscn")
