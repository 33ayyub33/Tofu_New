extends Control

var settings_file := "user://settings.cfg"  # Lokasi file konfigurasi

func _ready():
	if Global.music_a.is_playing():
		pass
	else:	
		Global.play_music_a()
		
	load_settings()  # Muat pengaturan saat menu dimulai


# Fungsi untuk memuat pengaturan dari file
func load_settings():
	var config := ConfigFile.new()
	if config.load(settings_file) == OK:
		var volume = config.get_value("audio", "volume", 0)  # Default volume 0 jika tidak ada
		var mute = config.get_value("audio", "mute", false)  # Default mute adalah false jika tidak ada
		
		# Terapkan pengaturan volume
		AudioServer.set_bus_volume_db(0, volume)
		AudioServer.set_bus_mute(0, mute)

# Tombol untuk memulai permainan
func _on_start_pressed():
	get_tree().change_scene_to_file("res://piilih_game.tscn")

# Tombol untuk membuka opsi/pengaturan
func _on_options_pressed():
	get_tree().change_scene_to_file("res://option_menu.tscn")

# Tombol untuk keluar dari permainan
func _on_quit_pressed():
	get_tree().quit()
