extends Control


@onready var orang_ngomong = $MarginContainer/reaksi_maskot
@onready var soal = $MarginContainer/soal


func _on_back_pressed():
	get_tree().change_scene_to_file("res://piilih_game.tscn")


func _on_retry_pressed():
	get_tree().change_scene_to_file("res://game_2.tscn")


func _on_home_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_keluar_2_1_pressed():
	get_tree().change_scene_to_file("res://piilih_game.tscn")
