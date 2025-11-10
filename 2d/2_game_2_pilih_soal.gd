extends Control


func _ready():
	if Global.music_d.is_playing():
		pass
	else:	
		Global.play_music_d()

func _on_keluar_2_1_pressed():
	get_tree().change_scene_to_file("res://piilih_game.tscn")



func _on_soal_1_pressed():
	get_tree().change_scene_to_file("res://2_game_2_baru.tscn")

func _on_soal_2_pressed():
	get_tree().change_scene_to_file("res://game_2_soal_2.tscn")
	

func _on_soal_3_pressed():
	get_tree().change_scene_to_file("res://game_2_soal_3.tscn")
	


func _on_soal_4_pressed():
	get_tree().change_scene_to_file("res://game_2_soal_4.tscn")
	


func _on_soal_5_pressed():
	pass # Replace with function body.


func _on_soal_6_pressed():
	pass # Replace with function body.


func _on_soal_7_pressed():
	pass # Replace with function body.


func _on_soal_8_pressed():
	pass # Replace with function body.
