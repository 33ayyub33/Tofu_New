extends Control

# Inisialisasi variabel
var current_soal = []  # Untuk menyimpan input dari ibu
var total_buah = 0
var max_total_buah = 10
var lives = 3  # Jumlah nyawa pemain
var is_waiting_for_answer = false
var last_number = 0  # Untuk menyimpan angka terakhir yang diinput

@onready var label = $Label
@onready var anim_show = $AnimationPlayer
@onready var button_jeruk = $"../Object/fruit/Jeruk"
@onready var button_semangka = $"../Object/fruit/Semangka"
@onready var button_apel = $"../Object/fruit/Apel"
@onready var button_nanas = $"../Object/fruit/Nanas"
@onready var button_pilihan = $"../Total_button"
@onready var label_darah = %darah
@onready var correct_sound = $"../Correct"
@onready var wrong_sound = $"../Error"
@onready var control_ibu_tanya = $"../control_Ibu_tanya"
@onready var ceklis_2 = $"../control_Ibu_tanya/ceklis2"
@onready var ibu_soal_input = $"../control_Ibu_tanya/IBU_SOAL_INPUT"
@onready var pil_a = $"../Total_button/pil_a"
@onready var pil_b = $"../Total_button/pil_b"
@onready var pil_c = $"../Total_button/pil_c"
@onready var pil_d = $"../Total_button/pil_d"

@onready var tombolo_ibu_angka_1 = $"../control_Ibu_tanya/TomboloIbuAngka"
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

func _ready():
	_hide_pilihan_jawaban()
	ceklis_2.connect("pressed", self._on_ceklis_pressed)
	_update_lives_display()

	# Menghubungkan event tombol buah
	tombolo_ibu_buah_1.connect("pressed", Callable(self, "_on_buah_input").bind("apel"))
	tombolo_ibu_buah_2.connect("pressed", Callable(self, "_on_buah_input").bind("nanas"))
	tombolo_ibu_buah_3.connect("pressed", Callable(self, "_on_buah_input").bind("jeruk"))
	tombolo_ibu_buah_4.connect("pressed", Callable(self, "_on_buah_input").bind("semangka"))

	# Menghubungkan event tombol angka
	tombolo_ibu_angka_1.connect("pressed", Callable(self, "_on_angka_input").bind(1))
	tombolo_ibu_angka_2.connect("pressed", Callable(self, "_on_angka_input").bind(2))
	tombolo_ibu_angka_3.connect("pressed", Callable(self, "_on_angka_input").bind(3))
	tombolo_ibu_angka_4.connect("pressed", Callable(self, "_on_angka_input").bind(4))
	tombolo_ibu_angka_5.connect("pressed", Callable(self, "_on_angka_input").bind(5))
	tombolo_ibu_angka_6.connect("pressed", Callable(self, "_on_angka_input").bind(6))
	tombolo_ibu_angka_7.connect("pressed", Callable(self, "_on_angka_input").bind(7))
	tombolo_ibu_angka_8.connect("pressed", Callable(self, "_on_angka_input").bind(8))
	tombolo_ibu_angka_9.connect("pressed", Callable(self, "_on_angka_input").bind(9))
	tombolo_ibu_angka_0.connect("pressed", Callable(self, "_on_angka_input").bind(0))

	# Menghubungkan event tombol buah untuk anak
	button_jeruk.connect("pressed", Callable(self, "_on_button_jeruk_pressed"))
	button_semangka.connect("pressed", Callable(self, "_on_button_semangka_pressed"))
	button_apel.connect("pressed", Callable(self, "_on_button_apel_pressed"))
	button_nanas.connect("pressed", Callable(self, "_on_button_nanas_pressed"))

# Fungsi untuk menyembunyikan pop-up setelah ibu memasukkan soal
func _on_ceklis_pressed():
	control_ibu_tanya.hide()
	_set_new_soal()

# Fungsi untuk menangani input angka dari Ibu
func _on_angka_input(angka: int):
	if total_buah < max_total_buah:  # Cek apakah total buah masih kurang dari maksimum
		if last_number == 0:  # Hanya izinkan input angka jika belum ada angka sebelumnya
			last_number = angka  # Simpan angka terakhir yang diinput
			print("Input angka:", last_number)
	else:
		print("Jumlah total buah tidak boleh lebih dari", max_total_buah)

# Fungsi untuk menangani input buah dari Ibu
func _on_buah_input(buah: String):
	if last_number > 0:  # Pastikan ada angka yang telah diinput
		current_soal.append(str(last_number) + " " + buah)  # Gabungkan angka dan buah
		total_buah += last_number  # Update total buah yang diambil
		label.text += str(last_number) + " " + buah + ", "  # Tampilkan di label
		print("Input buah:", current_soal)
		ibu_soal_input.text = _format_soal(current_soal)

		last_number = 0  # Reset angka terakhir setelah digunakan
		_show_input_summary()  # Tampilkan ringkasan input

# Fungsi untuk mendapatkan input dari Ibu
func _set_new_soal():
	label.text = "Ibu telah meminta: " + _format_soal(current_soal)  # Format input data untuk ditampilkan
	#_show_text()  # Tampilkan animasi teks

# Fungsi untuk memformat dan menampilkan ringkasan input
func _show_input_summary():
	if total_buah >= max_total_buah:
		label.text = "Ibu meminta total: " + _format_soal(current_soal)  # Gunakan fungsi format
		_hide_buah_buttons()  # Sembunyikan tombol buah
		is_waiting_for_answer = true  # Set waiting state untuk menunggu jawaban anak
		_show_pilihan_jawaban()  # Tampilkan pilihan jawaban
	else:
		print("Total buah yang diambil:", total_buah)

# Fungsi untuk memformat soal menjadi string yang rapi
func _format_soal(soal: Array) -> String:
	var result = ""
	var count = soal.size()
	
	for i in range(count):
		result += soal[i]
		if i < count - 2:
			result += ", "  # Tambahkan koma jika bukan dua yang terakhir
		elif i == count - 2:
			result += " dan "  # Tambahkan "dan" sebelum yang terakhir
	
	return result

# Fungsi untuk menyembunyikan tombol buah setelah input penuh
func _hide_buah_buttons():
	tombolo_ibu_buah_1.hide()
	tombolo_ibu_buah_2.hide()
	tombolo_ibu_buah_3.hide()
	tombolo_ibu_buah_4.hide()

# Fungsi untuk menampilkan pilihan jawaban
func _show_pilihan_jawaban():
	button_pilihan.show()  # Menampilkan tombol pilihan
	pil_a.text = str(total_buah)  # Menampilkan jumlah total buah yang diminta
	pil_b.text = str(total_buah + 1)  # Contoh pilihan jawaban yang salah
	pil_c.text = str(total_buah - 1)  # Contoh pilihan jawaban yang salah
	pil_d.text = str(total_buah + 2)  # Contoh pilihan jawaban yang salah

# Fungsi untuk menyembunyikan pilihan jawaban
func _hide_pilihan_jawaban():
	button_pilihan.hide()

# Fungsi untuk memeriksa jawaban dan mengurangi nyawa
func _check_jawaban(jawaban: int):
	if not is_waiting_for_answer:
		print("Tidak sedang menunggu jawaban.")
		return  # Jangan lakukan apapun jika tidak menunggu jawaban

	if jawaban == total_buah:
		label.text = "Jawaban benar! Ibu menerima semua buah."
		correct_sound.play()
		_reset_game()  # Reset permainan untuk soal baru
	else:
		lives -= 1
		wrong_sound.play()
		label.text = "Jawaban salah! Nyawa tersisa: " + str(lives)
		if lives <= 0:
			label.text = "Game Over!"
			_end_game()  # Panggil fungsi untuk mengakhiri permainan
		else:
			is_waiting_for_answer = false  # Reset status menunggu

# Fungsi untuk mereset permainan
func _reset_game():
	total_buah = 0
	current_soal.clear()
	last_number = 0  # Reset angka terakhir
	lives = 3  # Reset nyawa
	_update_lives_display()  # Update tampilan nyawa
	_hide_pilihan_jawaban()  # Sembunyikan pilihan jawaban

# Fungsi untuk mengakhiri permainan
func _end_game():
	_reset_game()  # Reset permainan dan tampilan
	label.text = "Game selesai! Tekan tombol untuk mulai lagi."
	# Di sini bisa ditambahkan logika untuk memulai ulang permainan

# Fungsi untuk menangani pilihan jawaban
func _on_pilihan_a_pressed():
	_check_jawaban(total_buah)  # Cek jawaban untuk pilihan A

func _on_pilihan_b_pressed():
	_check_jawaban(total_buah + 1)  # Cek jawaban untuk pilihan B

func _on_pilihan_c_pressed():
	_check_jawaban(total_buah - 1)  # Cek jawaban untuk pilihan C

func _on_pilihan_d_pressed():
	_check_jawaban(total_buah + 2)  # Cek jawaban untuk pilihan D

# Fungsi untuk menangani tombol buah dari anak
func _on_button_jeruk_pressed():
	_check_jawaban(total_buah)  # Ganti dengan jawaban yang sesuai

func _on_button_semangka_pressed():
	_check_jawaban(total_buah + 1)  # Ganti dengan jawaban yang sesuai

func _on_button_apel_pressed():
	_check_jawaban(total_buah - 1)  # Ganti dengan jawaban yang sesuai

func _on_button_nanas_pressed():
	_check_jawaban(total_buah + 2)  # Ganti dengan jawaban yang sesuai

# Fungsi untuk memperbarui tampilan nyawa
func _update_lives_display():
	label_darah.text = "Nyawa: " + str(lives)  # Update label nyawa
