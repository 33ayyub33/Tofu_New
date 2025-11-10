extends Control

@onready var tofuw_ngomong = $MarginContainer/reaksi_maskot/Tofuw_Ngomong
@onready var label = $MarginContainer/reaksi_maskot/Tofuw_Ngomong/Label  # Label untuk teks soal
@onready var anim_show = $MarginContainer/reaksi_maskot/Tofuw_Ngomong/AnimationPlayer
@onready var soal = $MarginContainer/soal
@onready var button_a = $jawab/A
@onready var button_b = $jawab/B
@onready var button_c = $jawab/C
@onready var button_d = $jawab/D
@onready var ceklis_2 = $ceklis2
@onready var undo = $undo
@onready var mascot_sprite = $MarginContainer/reaksi_maskot/Tofuw_Ngomong/Tanya
@onready var feedback_label = $jawab/FeedbackLabel
@onready var correct = $Correct
@onready var wrong = $Error
@onready var timer = $jawab/Timer
@onready var kumpulan_jawaban_label = $jawab/tumpukan_jawaban_label  # Label untuk menampilkan jawaban yang dipilih
@onready var darah_label = $jawab/Timer_Label  # Label untuk menampilkan waktu tersisa

var pilihan_jawaban = ["lan", "ja", "be", "ber"]
var jawaban_benar = "berbelanja"  # Jawaban yang benar
var selected_answer = []  # Menyimpan jawaban yang dipilih pengguna
var lives = 3  # Jumlah nyawa pemain

func _ready():
	if Global.music_d.is_playing():
		pass
	else:	
		Global.play_music_d()
	_set_button_text()  # Memanggil fungsi untuk mengisi opsi pada tombol
	feedback_label.text = ""
	selected_answer.clear()  # Reset jawaban yang dipilih di awal

	# Set timer waktu menjadi 60 detik
	timer.wait_time = 60
	timer.start()

	# Set teks soal
	label.text = "Apa yang sedang dilakukan Ibu?"  # Teks soal
	
	# Connect timer ke fungsi timeout menggunakan Callable
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	
	# Hubungkan sinyal tombol ke fungsi _on_button_pressed menggunakan Callable
	button_a.connect("pressed", Callable(self, "_on_button_A_pressed"))
	button_b.connect("pressed", Callable(self, "_on_button_B_pressed"))
	button_c.connect("pressed", Callable(self, "_on_button_C_pressed"))
	button_d.connect("pressed", Callable(self, "_on_button_D_pressed"))
	_update_lives_display()

func _update_lives_display():
	# Ganti sprite atau tampilkan sesuai dengan jumlah nyawa yang tersisa
	#nyawa_sprite.texture = preload("res://img/aset/game_1/nyawa.png")  # Asumsi ada sprite nyawa
	darah_label.text = "Kesempatan: " + str(lives) 
	
# Fungsi untuk mengecek apakah jawaban benar atau salah
func _on_ceklis_2_pressed():
	var jawaban_gabungan = ""
	for kata in selected_answer:
		jawaban_gabungan += kata

	print("Jawaban gabungan: ", jawaban_gabungan)
	print("Jawaban benar: ", jawaban_benar)

	if jawaban_gabungan == jawaban_benar:
		feedback_label.text = "Jawaban Benar!"
		update_sprite("benar")
		get_tree().change_scene_to_file("res://winner_2_soal_3.tscn")  # Pindah ke scene berikutnya jika benar
	else:
		feedback_label.text = "Jawaban salah, coba lagi"
		feedback_label.show()
		
		update_sprite("salah")
		wrong.play()
		lives -= 1  # Kurangi nyawa jika salah
		_update_lives_display()  # Perbarui tampilan nyawa
		if lives <= 0:
			_game_over()  # Panggil fungsi game over jika nyawa habis
		else :
			await get_tree().create_timer(2.0).timeout  # Tunggu 2 detik
			feedback_label.hide()
			

func _game_over():
	print("Game over! Nyawa habis.")  # Debugging output
	get_tree().change_scene_to_file("res://game_over_3.tscn")
	# Logika tambahan untuk menangani game over, seperti menampilkan layar akhir atau mengulang permainan.
	
# Fungsi untuk memilih jawaban dan menambahkannya ke array
func _on_button_A_pressed():
	_on_button_pressed(button_a)

func _on_button_B_pressed():
	_on_button_pressed(button_b)

func _on_button_C_pressed():
	_on_button_pressed(button_c)

func _on_button_D_pressed():
	_on_button_pressed(button_d)

func _on_button_pressed(button):
	if len(selected_answer) < 4:  # Batas maksimum 4 kata
		selected_answer.append(button.text)
		_update_kumpulan_jawaban_label()
		print("Ditambahkan ke jawaban: ", button.text)  # Cetak apa yang ditambahkan
		print("Jawaban saat ini: ", selected_answer)  # Cetak isi array setelah penambahan

# Fungsi undo untuk menghapus kata terakhir yang dipilih pengguna
func _on_undo_pressed():
	if selected_answer.size() > 0:
		var removed = selected_answer.pop_back()  # Mengambil elemen yang dihapus
		_update_kumpulan_jawaban_label()
		print("Dihapus dari jawaban: ", removed)  # Cetak apa yang dihapus
		print("Jawaban saat ini: ", selected_answer)  # Cetak isi array setelah penghapusan

# Fungsi untuk memperbarui label kumpulan jawaban yang dipilih
func _update_kumpulan_jawaban_label():
	kumpulan_jawaban_label.text = " ".join(selected_answer)

# Fungsi untuk update sprite sesuai kondisi (benar atau salah)
func update_sprite(state):
	if state == "benar":
		correct.play()
		mascot_sprite.texture = preload("res://img/aset/benar.png")
	elif state == "salah":
		wrong.play()
		mascot_sprite.texture = preload("res://img/aset/coba_lagi.png")
	else:
		mascot_sprite.texture = preload("res://img/aset/tanya.png")

# Fungsi untuk mengatur teks pada tombol a, b, c, d
func _set_button_text():
	button_a.text = pilihan_jawaban[0]
	button_b.text = pilihan_jawaban[1]
	button_c.text = pilihan_jawaban[2]
	button_d.text = pilihan_jawaban[3]



func _on_keluar_2_1_pressed():
	get_tree().change_scene_to_file("res://2_game_2_pilih_SOAL.tscn")
