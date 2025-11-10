extends Control

@onready var label = $Label
@onready var anim_show = $AnimationPlayer
@onready var button_jeruk = $"../Object/fruit/Jeruk"
@onready var button_semangka = $"../Object/fruit/Semangka"
@onready var button_apel = $"../Object/fruit/Apel"
@onready var button_nanas = $"../Object/fruit/Nanas"
@onready var button_pilihan = $"../Total_button"
@onready var maskot_sprite = $maskot
@onready var nyawa_sprite = $"../Nyawa" # Asumsi ada sprite nyawa di UI
@onready var trolly_animation = $"../animasi/anim/buah_anim" # Sprite atau node untuk animasi troli
@onready var label_darah = %darah
@onready var correct_sound = $"../Correct"
@onready var wrong_sound = $"../Error"

@onready var gabungan_soal = $"../control_Ibu_tanya/Gabungan_soal"
@onready var judul = $"../control_Ibu_tanya/Judul"

@onready var tombolo_ibu_angka = $"../control_Ibu_tanya/TomboloIbuAngka"
@onready var tombolo_ibu_angka_2 = $"../control_Ibu_tanya/TomboloIbuAngka2"
@onready var tombolo_ibu_angka_3 = $"../control_Ibu_tanya/TomboloIbuAngka3"
@onready var tombolo_ibu_angka_4 = $"../control_Ibu_tanya/TomboloIbuAngka4"
@onready var tombolo_ibu_angka_5 = $"../control_Ibu_tanya/TomboloIbuAngka5"
@onready var tombolo_ibu_angka_6 = $"../control_Ibu_tanya/TomboloIbuAngka6"
@onready var tombolo_ibu_angka_7 = $"../control_Ibu_tanya/TomboloIbuAngka7"
@onready var tombolo_ibu_angka_8 = $"../control_Ibu_tanya/TomboloIbuAngka8"
@onready var tombolo_ibu_angka_9 = $"../control_Ibu_tanya/TomboloIbuAngka9"
@onready var tombolo_ibu_angka_0 = $"../control_Ibu_tanya/TomboloIbuAngka0"
@onready var tombolo_ibu_buah_1 = $"../control_Ibu_tanya/TomboloIbu_buah1"
@onready var tombolo_ibu_buah_2 = $"../control_Ibu_tanya/TomboloIbu_buah2"
@onready var tombolo_ibu_buah_3 = $"../control_Ibu_tanya/TomboloIbu_buah3"
@onready var tombolo_ibu_buah_4 = $"../control_Ibu_tanya/TomboloIbu_buah4"




var angka = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
var soal = [
	"Tolong ambilkan ",
	"Tolong beli ",
	"Saya ingin beli ",
	"Mau beli ",
	"Beli ",
	"Saya mau beli ",
	"Halo.. Saya mau beli "
]
var buah = ["Jeruk", "Semangka", "Apel", "Nanas"]

var current_soal = ""
var current_angka = 0
var current_buah = ""
var total_buah = 0
var lives = 3  # Jumlah nyawa pemain
var is_waiting_for_answer = false

func _ready():
	_hide_pilihan_jawaban()
	randomize()  # Menginisialisasi random seed
	_set_new_soal()
	button_jeruk.connect("pressed", Callable(self, "_on_button_jeruk_pressed"))
	button_semangka.connect("pressed", Callable(self, "_on_button_semangka_pressed"))
	button_apel.connect("pressed", Callable(self, "_on_button_apel_pressed"))
	button_nanas.connect("pressed", Callable(self, "_on_button_nanas_pressed"))
	_update_lives_display()  # Tampilkan jumlah nyawa

# Fungsi untuk mengacak dan membuat soal baru
func _set_new_soal():
	current_soal = soal[randi() % soal.size()]
	current_angka = int(angka[randi() % angka.size()])
	current_buah = buah[randi() % buah.size()]  # Buah pertama

	## Tambahkan logika untuk meminta lebih dari 1 jenis buah
	#if randi() % 2 == 0:  # 50% kemungkinan meminta lebih dari 1 jenis
		#var buah_kedua = buah[randi() % buah.size()]  # Buah kedua
		#while buah_kedua == current_buah:  # Pastikan buah kedua tidak sama dengan buah pertama
			#buah_kedua = buah[randi() % buah.size()]
		#current_buah += " dan " + buah_kedua  # Gabungkan kedua buah

		## Cek jika meminta lebih dari 2 jenis buah
		#if randi() % 2 == 0:  # 50% kemungkinan meminta lebih dari 2 jenis
			#var buah_ketiga = buah[randi() % buah.size()]  # Buah ketiga
			#while buah_ketiga == current_buah or buah_ketiga == buah_kedua:  # Pastikan tidak sama
				#buah_ketiga = buah[randi() % buah.size()]
			#current_buah += " dan " + buah_ketiga  # Gabungkan ketiga buah

	# Buat kalimat soal
	#var kalimat = current_soal + str(current_angka) + " " + current_buah  
	var kalimat = current_soal + str(current_angka) + " " + current_buah  

	# Tampilkan kalimat di label
	label.text = kalimat
	# Tampilkan animasi
	_show_text()

	total_buah = 0  # Reset total buah
	print("Soal baru:", label.text)  # Debugging output

func _on_button_jeruk_pressed():
	_check_buah("Jeruk")

func _on_button_semangka_pressed():
	_check_buah("Semangka")

func _on_button_apel_pressed():
	_check_buah("Apel")

func _on_button_nanas_pressed():
	_check_buah("Nanas")

# Fungsi untuk mengecek apakah buah yang dipilih sesuai dengan soal
func _check_buah(buah_dipilih: String):
	# Cek apakah buah dipilih sesuai dengan current_buah

	if is_waiting_for_answer:
		# Jika sedang menunggu jawaban, jangan izinkan menambah buah
		print("Menunggu jawaban pengguna, tidak bisa menambah buah.")
		return

	if buah_dipilih == current_buah or (current_buah.find("dan") != -1 and buah_dipilih in current_buah):
		total_buah += 1
		_maskot_benar()
		correct_sound.play()
		_animate_fruit_to_trolley()  # Panggil animasi saat memilih buah yang benar
		if total_buah == current_angka:
			label.text = "Berapa total buah sekarang?"
			_show_text()
			_show_pilihan_jawaban()
			is_waiting_for_answer = true 
			print("Total: ", total_buah)
		else:
			label.text = "Tambah " + str(current_angka - total_buah) + " " + current_buah + " lagi!"
			_show_text()
			print("Total: ", total_buah)
		
	else:
		lives -= 1  # Kurangi nyawa jika salah
		_update_lives_display()  # Perbarui tampilan nyawa
		wrong_sound.play()
		_maskot_gagal()
		if lives <= 0:
			_game_over()  # Panggil fungsi game over jika nyawa habis
	


# Fungsi untuk memperbarui tampilan nyawa
func _update_lives_display():
	# Ganti sprite atau tampilkan sesuai dengan jumlah nyawa yang tersisa
	#nyawa_sprite.texture = preload("res://img/aset/game_1/nyawa.png")  # Asumsi ada sprite nyawa
	label_darah.text = "Kesempatan: " + str(lives) 

# Fungsi untuk menampilkan animasi saat buah dipilih dengan benar
func _animate_fruit_to_trolley():
	if current_buah.find("Apel") != -1:
		trolly_animation.play("apel_gerak")  # Mainkan animasi untuk apel
		print("Animasi apel digeser ke troli")  # Debugging output
	elif current_buah.find("Semangka") != -1:
		trolly_animation.play("semangka_gerak")  # Mainkan animasi untuk semangka
		print("Animasi semangka digeser ke troli")  # Debugging output
	elif current_buah.find("Nanas") != -1:
		trolly_animation.play("nanas_gerak")  # Mainkan animasi untuk nanas
		print("Animasi nanas digeser ke troli")  # Debugging output
	elif current_buah.find("Jeruk") != -1:
		trolly_animation.play("jeruk_gerak")  # Mainkan animasi untuk jeruk
		print("Animasi jeruk digeser ke troli")  # Debugging output

# Menampilkan tombol pilihan jawaban angka
func _show_pilihan_jawaban():
	button_pilihan.show()

	# Daftar untuk menyimpan pilihan jawaban unik
	var pilihan_jawaban = []

	# Masukkan jawaban yang benar ke dalam daftar
	pilihan_jawaban.append(current_angka)

	# Tambahkan 3 angka acak yang berbeda dari current_angka
	while pilihan_jawaban.size() < 4:
		var jawaban_acak = current_angka + randi() % 5 - 2  # Buat angka acak dekat dengan jawaban
		if jawaban_acak != current_angka and jawaban_acak not in pilihan_jawaban:
			pilihan_jawaban.append(jawaban_acak)

	# Acak urutan dari pilihan jawaban
	pilihan_jawaban.shuffle()

	# Tampilkan angka acak di setiap tombol
	for i in range(4):
		var button = button_pilihan.get_child(i) as Button
		var jawaban = pilihan_jawaban[i]  # Ambil angka dari daftar
		button.text = str(jawaban)
		#if button.connect("pressed", Callable(self, "_check_jawaban").bind(str(jawaban))):
		button.disconnect("pressed", Callable(self, "_check_jawaban").bind(str(jawaban)))
		button.connect("pressed", Callable(self, "_check_jawaban").bind(str(jawaban)))

		# Debugging output untuk setiap tombol
		print("Tombol", i, "diisi dengan jawaban:", button.text)

	print("Pilihan jawaban muncul:", pilihan_jawaban)  # Debugging output

# Mengecek jawaban pengguna dari pilihan angka
func _check_jawaban(jawaban: String):
	var jawaban_int = int(jawaban)  # Konversi jawaban ke integer
	print("Jawaban dipilih:", jawaban_int, " | Jawaban benar:", current_angka)  # Debugging output
	if jawaban_int == current_angka:
		_maskot_benar()
		correct_sound.play()
		_hide_pilihan_jawaban()
		print("total buah: ", total_buah)
		print("current angka: ", current_angka)
		total_buah = 0  # Reset total buah setelah jawaban benar
		jawaban_int = 0
		print("jawbaan_int", jawaban_int)
		_set_new_soal()  # Soal baru setelah jawaban benar
		is_waiting_for_answer = false
	else:
		_maskot_gagal()
		wrong_sound.play()
		lives -= 1  # Kurangi nyawa jika salah
		_update_lives_display()  # Perbarui tampilan nyawa
		if lives <= 0:
			_game_over()  # Panggil fungsi game over jika nyawa habis

# Menyembunyikan button pilihan jawaban
func _hide_pilihan_jawaban():
	button_pilihan.hide()
	print("Pilihan jawaban disembunyikan")  # Debugging output

# Fungsi untuk mengganti maskot menjadi benar
func _maskot_benar():
	maskot_sprite.texture = preload("res://img/aset/benar.png")
	#anim_show.play("correct")
	print("Jawaban benar!")  # Debugging output

# Fungsi untuk mengganti maskot menjadi salah
func _maskot_gagal():
	maskot_sprite.texture = preload("res://img/aset/coba_lagi.png")
	#anim_show.play("wrong")
	print("Jawaban salah!")  # Debugging output

# Fungsi untuk menangani keadaan game over
func _game_over():
	print("Game over! Nyawa habis.")  # Debugging output
	get_tree().change_scene_to_file("res://gameover_1.tscn")
	# Logika tambahan untuk menangani game over, seperti menampilkan layar akhir atau mengulang permainan.

# Fungsi untuk memainkan animasi
func _show_text():
	anim_show.play("ratio")
	print("Animasi teks diputar")  # Debugging output
	
#func show_end_buttons():
	#button_pilihan.show()
