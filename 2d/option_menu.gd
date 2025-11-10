extends Control

var settings_file := "user://settings.cfg"  # Lokasi file konfigurasi
var MAX_VOLUME_DB := 2  # Batas maksimal volume dalam desibel (5 dB)
var MIN_VOLUME_DB := -30  # Batas minimal volume dalam desibel

func _ready():
	if Global.music_a.is_playing():
		pass
	else:	
		Global.play_music_a()
	
	load_settings()  # Muat pengaturan saat scene dimulai

func _on_volume_value_changed(value):
	# Konversi nilai slider (0-100) ke desibel (-80 sampai 5)
	var volume_db = lerp(MIN_VOLUME_DB, MAX_VOLUME_DB, value / 100.0)
	AudioServer.set_bus_volume_db(0, volume_db)
	save_settings(volume_db, AudioServer.is_bus_mute(0))  # Simpan volume dan mute

func _on_mute_toggled(toggled_on):
	AudioServer.set_bus_mute(0, toggled_on)
	save_settings(AudioServer.get_bus_volume_db(0), toggled_on)  # Simpan mute dan volume

func _on_kembali_pressed():

	get_tree().change_scene_to_file("res://menu.tscn")

# Fungsi untuk menyimpan pengaturan ke file
func save_settings(volume, mute):
	var config := ConfigFile.new()
	config.set_value("audio", "volume", volume)
	config.set_value("audio", "mute", mute)
	config.save(settings_file)

# Fungsi untuk memuat pengaturan dari file
func load_settings():
	var config := ConfigFile.new()
	if config.load(settings_file) == OK:
		# Muat volume dan mute dari file
		var volume_db = config.get_value("audio", "volume", 0)  # Default volume 0 dB jika tidak ada
		var mute = config.get_value("audio", "mute", false)  # Default mute adalah false jika tidak ada
		
		# Konversi volume dari desibel ke nilai slider (0-100)
		var volume_slider_value = inverse_lerp(MIN_VOLUME_DB, MAX_VOLUME_DB, volume_db)
		$MarginContainer2/VBoxContainer2/HBoxContainer/vol/TextureRect/volume.value = volume_slider_value * 100
		
		# Atur volume dan mute
		AudioServer.set_bus_volume_db(0, volume_db)
		$MarginContainer2/VBoxContainer2/HBoxContainer/vol/TextureRect/mute.button_pressed = mute
		AudioServer.set_bus_mute(0, mute)

# Fungsi linear interpolation terbalik untuk mendapatkan nilai slider dari desibel
func inverse_lerp(a, b, value):
	return (value - a) / (b - a)
