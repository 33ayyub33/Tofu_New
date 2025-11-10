extends Control



func _ready():
	if Global.music_b.is_playing() or Global.music_c.is_playing() or Global.music_d.is_playing() or Global.music_e.is_playing():
		Global.play_music_a()
	elif not Global.music_a.is_playing():
		# Jika musik A tidak sedang dimainkan, mainkan musik A
		Global.play_music_a()
	else:
		pass

	
func _on_menghitung_pressed():
	get_tree().change_scene_to_file("res://game_1.tscn")



func _on_keluar_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_membaca_pressed():
	get_tree().change_scene_to_file("res://2_game_2_pilih_SOAL.tscn")


func _on_menulis_pressed():
	get_tree().change_scene_to_file("res://tres/game_3_pilih_soal.tscn")
