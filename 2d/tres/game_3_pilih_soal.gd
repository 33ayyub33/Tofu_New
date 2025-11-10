extends Control



func _ready():
	if Global.music_c.is_playing():
		pass
	else:	
		Global.play_music_c()
	
func _on_keluar_2_1_pressed():
	get_tree().change_scene_to_file("res://piilih_game.tscn")


func _on_makan_pressed():
	
	get_tree().change_scene_to_file("res://tres/game_3_soal_2.tscn")


func _on_kursi_pressed():
	
	get_tree().change_scene_to_file("res://tres/game_3_soal_3.tscn")
	


func _on_buku_pressed():
	
	get_tree().change_scene_to_file("res://game_3.tscn")
	


func _on_pensil_pressed():
	
	get_tree().change_scene_to_file("res://tres/game_3_soal_4.tscn")
	
