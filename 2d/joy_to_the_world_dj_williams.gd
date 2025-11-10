extends AudioStreamPlayer

var is_playing := false  # Untuk menyimpan status apakah audio sedang diputar
var playback_position := 0.0  # Untuk menyimpan posisi terakhir audio

# Fungsi ini dipanggil saat node siap
func _ready():
	# Jika audio sudah pernah diputar sebelumnya, lanjutkan dari posisi terakhir
	if is_playing:
		play(playback_position)

# Fungsi untuk mulai memutar audio tanpa mengulang dari awal
func start_audio():
	if not playing:
		play()
	is_playing = true  # Tandai bahwa audio sedang diputar

# Fungsi untuk menghentikan audio dan menyimpan posisinya
func stop_audio():
	playback_position = get_playback_position()  # Simpan posisi saat ini
	stop()
	is_playing = false  # Tandai bahwa audio telah berhenti
	
	#
#func _on_kembali_pressed():
	#glob_audio.change_scene_to_file("res://menu.tscn")
