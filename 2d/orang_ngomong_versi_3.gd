extends Control

@onready var label =$"../Label_gelembung"
@onready var anim_show = $AnimationPlayer
@onready var button_jeruk = $"../Object/fruit/Jeruk"
@onready var button_semangka = $"../Object/fruit/Semangka"
@onready var button_apel = $"../Object/fruit/Apel"
@onready var button_nanas = $"../Object/fruit/Nanas"
@onready var button_pilihan = $"../Total_button"
@onready var maskot_sprite = $maskot
@onready var nyawa_sprite = $"../Nyawa"
@onready var trolly_animation = $"../animasi/anim/buah_anim"
@onready var label_darah = %darah
@onready var correct_sound = $"../Correct"
@onready var wrong_sound = $"../Error"

var buah = ["Jeruk", "Semangka", "Apel", "Nanas"]
var current_buah = []
var current_angka = []
var jumlah_buah_terambil = {}  # Untuk melacak jumlah buah yang sudah diambil
var total_buah = 0
var lives = 3
var is_waiting_for_answer = false
var buah_dipilih = ""  # Variabel untuk menyimpan buah yang dipilih oleh pengguna
var jum_aple = 1

func _ready():
	_hide_pilihan_jawaban()
	randomize()
	_set_new_soal()
	button_jeruk.connect("pressed", Callable(self, "_on_button_jeruk_pressed"))
	button_semangka.connect("pressed", Callable(self, "_on_button_semangka_pressed"))
	button_apel.connect("pressed", Callable(self, "_on_button_apel_pressed"))
	button_nanas.connect("pressed", Callable(self, "_on_button_nanas_pressed"))
	_update_lives_display()

# Fungsi untuk mengacak dan membuat soal baru
func _set_new_soal():
	var pilihan_jenis_soal = randi() % 4 + 1  # Pilih jumlah buah antara 1-4
	current_buah.clear()
	current_angka.clear()
	jumlah_buah_terambil.clear()  # Reset jumlah buah yang sudah diambil

	for i in range(pilihan_jenis_soal):
		var buah_acak = buah[randi() % buah.size()]
		
		# Jika jumlah buah yang diminta lebih dari 1, hindari buah yang sama
		while buah_acak in current_buah and pilihan_jenis_soal > 1:
			buah_acak = buah[randi() % buah.size()]  # Pilih buah lain jika duplikat ditemukan
		
		var jumlah_acak = randi() % 5 + 1  # Angka acak antara 1-5
		current_buah.append(buah_acak)
		current_angka.append(jumlah_acak)
		jumlah_buah_terambil[buah_acak] = 0  # Inisialisasi jumlah buah terambil ke 0

	# Buat kalimat soal awal
	_update_label()
	total_buah = 0
	print("Soal baru:", label.text)


func _on_button_jeruk_pressed():
	_check_buah("Jeruk")

func _on_button_semangka_pressed():
	_check_buah("Semangka")

func _on_button_apel_pressed():
	_check_buah("Apel")

func _on_button_nanas_pressed():
	_check_buah("Nanas")

# Fungsi untuk mengecek apakah buah yang dipilih sesuai dengan soal
func _check_buah(buah_dipilih_param: String):
	if is_waiting_for_answer:
		print("Menunggu jawaban pengguna, tidak bisa menambah buah.")
		return

	buah_dipilih = buah_dipilih_param  # Simpan buah yang dipilih
	var index = current_buah.find(buah_dipilih)
	
	if index != -1:
		# Cek apakah jumlah buah yang diambil sudah cukup
		if jumlah_buah_terambil[buah_dipilih] >= current_angka[index]:
			# Jika sudah cukup, kurangi nyawa dan beri pesan
			lives -= 1
			_update_lives_display()
			label.text = "Buah " + buah_dipilih + " sudah cukup! Jangan ambil lagi."
			_show_text()
			wrong_sound.play()
			_maskot_gagal()
			if lives <= 0:
				_game_over()
			return

		# Tambah jumlah buah yang diambil
		jumlah_buah_terambil[buah_dipilih] += 1
		total_buah += 1
		_animate_fruit_to_trolley()  # Animate the fruit moving to the trolley
		_maskot_benar()
		correct_sound.play()

		# Cek apakah semua buah sudah diambil
		if _semua_buah_terambil():
			label.text = "Halo dek, berapa total buah sekarang?"
			_show_text()
			_show_pilihan_jawaban()  # Tampilkan tombol pilihan jawaban
			is_waiting_for_answer = true
			print("Total: ", total_buah)
		else:
			_update_label()  # Update label with remaining fruits
	else:
		# Jika buah yang dipilih tidak valid, kurangi nyawa
		lives -= 1
		_update_lives_display()
		wrong_sound.play()
		_maskot_gagal()
		if lives <= 0:
			_game_over()

var semua_buah_terambil = true
func _update_label():
	var kalimat = "Halo Ibu, ayo ambil "
	  # Assume all fruits are taken
	
	for i in range(current_buah.size()):
		var jumlah_sisa = current_angka[i] - jumlah_buah_terambil[current_buah[i]]
		if jumlah_sisa > 0:
			kalimat += str(jumlah_sisa) + " " + current_buah[i] + ", "
			semua_buah_terambil = false  # Not all fruits are taken yet

	# Remove the trailing comma and space manually if they exist
	if kalimat.ends_with(", "):
		kalimat = kalimat.substr(0, kalimat.length() - 2)  # Remove the last ", "



	label.text = kalimat
	_show_text()





# Fungsi untuk mengecek apakah semua buah sudah diambil
func _semua_buah_terambil() -> bool:
	for i in range(current_buah.size()):
		if jumlah_buah_terambil[current_buah[i]] < current_angka[i]:
			return false
	return true

# Fungsi untuk memperbarui tampilan nyawa
func _update_lives_display():
	label_darah.text = "Kesempatan: " + str(lives)

# Fungsi untuk menampilkan animasi saat buah dipilih dengan benar
func _animate_fruit_to_trolley():
	match buah_dipilih:
		"Apel":
			# If 1 apple has been collected, play the first apple animation
			if jumlah_buah_terambil["Apel"] == 1:
				trolly_animation.play("apel_gerak")
			elif jumlah_buah_terambil["Apel"] == 2:
				trolly_animation.play("apel_gerak_2")
			elif jumlah_buah_terambil["Apel"] == 3:
				trolly_animation.play("apel_gerak_3")
			elif jumlah_buah_terambil["Apel"] == 4:
				trolly_animation.play("apel_gerak_4")
			elif jumlah_buah_terambil["Apel"] == 5:
				trolly_animation.play("apel_gerak_5")
		"Semangka":
			if jumlah_buah_terambil["Semangka"] == 1:
				trolly_animation.play("semangka_gerak")
			if jumlah_buah_terambil["Semangka"] == 2:
				trolly_animation.play("semangka_gerak_2")
			if jumlah_buah_terambil["Semangka"] == 3:
				trolly_animation.play("semangka_gerak_3")
			if jumlah_buah_terambil["Semangka"] == 4:
				trolly_animation.play("semangka_gerak_4")
			if jumlah_buah_terambil["Semangka"] == 5:
				trolly_animation.play("semangka_gerak")
			
		"Nanas":
			if jumlah_buah_terambil["Nanas"] == 1:
				trolly_animation.play("nanas_gerak")
			elif jumlah_buah_terambil["Nanas"] == 2:
				trolly_animation.play("nanas_gerak_2")
			elif jumlah_buah_terambil["Nanas"] == 3:
				trolly_animation.play("nanas_gerak_3")
			elif jumlah_buah_terambil["Nanas"] == 4:
				trolly_animation.play("nanas_gerak_4")
			elif jumlah_buah_terambil["Nanas"] == 5:
				trolly_animation.play("nanas_gerak_5")
		"Jeruk":
			if jumlah_buah_terambil["Jeruk"] == 1:
				trolly_animation.play("jeruk_gerak")
			if jumlah_buah_terambil["Jeruk"] == 2:
				trolly_animation.play("jeruk_gerak_2")
			if jumlah_buah_terambil["Jeruk"] == 3:
				trolly_animation.play("jeruk_gerak_3")
			if jumlah_buah_terambil["Jeruk"] == 4:
				trolly_animation.play("jeruk_gerak_4")
			if jumlah_buah_terambil["Jeruk"] == 5:
				trolly_animation.play("jeruk_gerak_5")
			
func _reset_anim():
	trolly_animation.play("RESET")

# Menampilkan tombol pilihan jawaban angka
func _show_pilihan_jawaban():
	button_pilihan.show()
	var pilihan_jawaban = []
	pilihan_jawaban.append(total_buah)  # Jawaban yang benar
	while pilihan_jawaban.size() < 4:
		var jawaban_acak = total_buah + randi() % 5 - 2
		if jawaban_acak != total_buah and jawaban_acak not in pilihan_jawaban:
			pilihan_jawaban.append(jawaban_acak)
	pilihan_jawaban.shuffle()

	for i in range(4):
		var button = button_pilihan.get_child(i) as Button
		var jawaban = pilihan_jawaban[i]
		button.text = str(jawaban)
		#button.connect("pressed", Callable(self, "_check_jawaban").bind(str(jawaban)))
		#button.disconnect("pressed", Callable(self, "_check_jawaban").bind(str(jawaban)))
		# Callable dengan parameter jawaban yang dibind
		var callable_jawaban = Callable(self, "_check_jawaban").bind(str(jawaban))

		# Cek apakah tombol sudah terhubung dengan sinyal 'pressed'
		if button.is_connected("pressed", callable_jawaban):
			# Jika terhubung, putuskan dulu koneksinya
			button.disconnect("pressed", callable_jawaban)
			print("Koneksi sinyal 'pressed' diputus.")
			
		# Setelah koneksi sebelumnya diputus atau jika tidak ada koneksi, sambungkan sinyal yang baru
		button.connect("pressed", callable_jawaban)
		print("Sinyal 'pressed' berhasil terhubung kembali.")

	print("Pilihan jawaban muncul:", pilihan_jawaban)

# Mengecek jawaban pengguna dari pilihan angka
func _check_jawaban(jawaban: String):
	var jawaban_int = int(jawaban)
	print("Jawaban dipilih:", jawaban_int, " | Jawaban benar:", total_buah)
	if jawaban_int == total_buah:
		_maskot_benar()
		correct_sound.play()
		_hide_pilihan_jawaban()
		total_buah = 0
		_reset_anim()
		_set_new_soal()
		is_waiting_for_answer = false
	else:
		_maskot_gagal()
		wrong_sound.play()
		lives -= 1
		_update_lives_display()
		if lives <= 0:
			_game_over()

# Menyembunyikan button pilihan jawaban
func _hide_pilihan_jawaban():
	button_pilihan.hide()
	print("Pilihan jawaban disembunyikan")

# Fungsi untuk mengganti maskot menjadi benar
func _maskot_benar():
	maskot_sprite.texture = preload("res://img/aset/benar.png")
	print("Jawaban benar!")

# Fungsi untuk mengganti maskot menjadi salah
func _maskot_gagal():
	maskot_sprite.texture = preload("res://img/aset/coba_lagi.png")
	print("Jawaban salah!")

# Fungsi untuk menangani keadaan game over
func _game_over():
	print("Game over! Nyawa habis.")
	get_tree().change_scene_to_file("res://gameover_1.tscn")

# Fungsi untuk memainkan animasi
func _show_text():
	anim_show.play("ratio")
	print("Animasi teks diputar")
