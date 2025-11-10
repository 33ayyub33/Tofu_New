extends TextureRect  # Menggunakan TextureRect sebagai node utama

@onready var tofuw_ngomong = $"../../reaksi_maskot/Tofuw_Ngomong"  # Referensi ke script Tofuw Ngomong
@onready var label = $"../../reaksi_maskot/Tofuw_Ngomong/Label"
@onready var button_A = $"../../../jawab/A"
@onready var button_B = $"../../../jawab/B"
@onready var button_C = $"../../../jawab/C"  # Perbaikan ini
@onready var button_D = $"../../../jawab/D"
@onready var feedback_label = $"../../../jawab/FeedbackLabel"  # Label untuk feedback benar/salah
@onready var mascot_sprite = $"../../reaksi_maskot/Tofuw_Ngomong/Tanya"  # Node sprite untuk maskot
@onready var timer_label = $"../../../jawab/Timer_Label"  # Label untuk timer
@onready var correct = $"../../../Correct"
@onready var wrong = $"../../../Error"

# Tombol baru
@onready var button_back = $"../../../BACK"  # Tombol Back
@onready var button_retry =  $"../../../RETRY" # Tombol Retry
@onready var button_home =  $"../../../HOME"  # Tombol Home

# Daftar jalur gambar yang sesuai dengan pertanyaan
var question_image_map = [
	"res://img/aset/game_2/apel_mangga.png",  # Soal 1
	"res://img/aset/game_2/baca_buku.png",     # Soal 2
	"res://img/aset/game_2/bli_buku.png",      # Soal 3
	"res://img/aset/game_2/bli_tofu.png",      # Soal 4
	"res://img/aset/game_2/num_cucu.png",      # Soal 5
	"res://img/aset/game_2/nyapu.png"           # Soal 6
]

# Daftar pertanyaan dan pilihan jawaban
var questions = [
	"Apa yang dibawa anak itu?",
	"Apa yang sedang Budi lakukan?",
	"Apa yang dibeli oleh Boby?",
	"Apa yang dibeli oleh Santo?",
	"Apa yang sedang Andi lakukan?",
	"Apa yang Nina lakukan?"
]

var pilihan_soal = [
	["a) Apel dan Manggis", "b) Nanas dan Rambutan", "c) Jeruk dan Apel", "d) Apel dan Mangga"],
	["a) Membaca buku", "b) Bermain layangan", "c) Meminum Susu", "d) Menggambar"],
	["a) Pensil", "b) Pulpen", "c) Buku", "d) Penggaris"],
	["a) Tahu", "b) Tempe", "c) Nanas", "d) Wajan"],
	["a) Memakan Rambutan", "b) Memakai Sepatu", "c) Meminum Susu", "d) Berlari"],
	["a) Menyapu", "b) Mencuci", "c) Mengajar", "d) Menyanyikan lagu"]
]

# Jawaban yang benar untuk setiap soal (indeks mengikuti urutan pertanyaan yang tidak diacak)
var correct_answers = ["a", "a", "c", "a", "c", "a"]

var current_question = 0  # Indeks pertanyaan saat ini
var selected_answer = ""  # Untuk menyimpan jawaban yang dipilih
var timer_duration = 5  # Durasi timer dalam detik
var timer: Timer = null  # Instance timer

func _ready():
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	custom_minimum_size = Vector2(300, 300)  # Ukuran minimum gambar
	
	randomize_questions()  # Acak pertanyaan dan data terkait
	show_question()  # Tampilkan pertanyaan pertama

	# Menghubungkan tombol dengan fungsi cek jawaban menggunakan Callable
	button_A.connect("pressed", Callable(self, "_on_button_A_pressed"))
	button_B.connect("pressed", Callable(self, "_on_button_B_pressed"))
	button_C.connect("pressed", Callable(self, "_on_button_C_pressed"))
	button_D.connect("pressed", Callable(self, "_on_button_D_pressed"))

	# Menghubungkan tombol Back, Retry, dan Home
	button_back.connect("pressed", Callable(self, "_on_button_back_pressed"))
	button_retry.connect("pressed", Callable(self, "_on_button_retry_pressed"))
	button_home.connect("pressed", Callable(self, "_on_button_home_pressed"))

# Fungsi untuk mengacak pertanyaan dan data terkait
func randomize_questions():
	var indices = []
	for i in range(questions.size()):
		indices.append(i)
	indices.shuffle()  # Mengacak indeks

	# Buat daftar baru berdasarkan indeks yang teracak
	var shuffled_questions = []
	var shuffled_images = []
	var shuffled_pilihan = []
	var shuffled_answers = []

	for index in indices:
		shuffled_questions.append(questions[index])
		shuffled_images.append(question_image_map[index])
		shuffled_pilihan.append(pilihan_soal[index])
		shuffled_answers.append(correct_answers[index])

	questions = shuffled_questions
	question_image_map = shuffled_images
	pilihan_soal = shuffled_pilihan
	correct_answers = shuffled_answers

# Fungsi untuk menampilkan gambar dan soal
func show_question():
	if current_question < questions.size():
		# Tampilkan gambar soal yang sesuai dengan pertanyaan
		var image_path = question_image_map[current_question]  # Ambil gambar dari peta
		var image_texture = load(image_path)
		if image_texture:
			self.texture = image_texture  # Set texture langsung ke TextureRect
		
		label.text = questions[current_question]  # Tampilkan pertanyaan di label
		update_answers(current_question)  # Panggil fungsi untuk memperbarui pilihan jawaban
		update_sprite("tanya")  # Set sprite maskot ke tanya
		_show_text()  # Tampilkan animasi untuk soal
		start_timer()  # Reset timer untuk soal baru
	else:
		hide_all_elements()  # Sembunyikan semua elemen
		get_tree().change_scene_to_file("res://gameover_2.tscn")
		#show_end_buttons()  # Tampilkan tombol akhir

# Fungsi untuk menyembunyikan semua elemen tampilan
func hide_all_elements():
	label.hide()
	button_A.hide()
	button_B.hide()
	button_C.hide()
	button_D.hide()
	mascot_sprite.hide()
	timer_label.hide()
	feedback_label.hide()

# Fungsi untuk menampilkan tombol Back, Retry, dan Home
#func show_end_buttons():
	#button_back.show()
	#button_retry.show()
	#button_home.show()

# Fungsi untuk memperbarui pilihan jawaban sesuai dengan soal yang ditampilkan
func update_answers(index):
	button_A.text = pilihan_soal[index][0]
	button_B.text = pilihan_soal[index][1]
	button_C.text = pilihan_soal[index][2]
	button_D.text = pilihan_soal[index][3]
	feedback_label.text = ""  # Kosongkan feedback setiap kali soal baru muncul
	selected_answer = ""  # Reset jawaban yang dipilih

# Fungsi untuk memperbarui sprite maskot sesuai jawaban
func update_sprite(state):
	if state == "benar":
		correct.play()
		mascot_sprite.texture = preload("res://img/aset/benar.png")  # Ganti dengan path ke sprite "Benar"
	elif state == "salah":
		wrong.play()
		mascot_sprite.texture = preload("res://img/aset/coba_lagi.png")  # Ganti dengan path ke sprite "Salah"
	else:
		mascot_sprite.texture = preload("res://img/aset/tanya.png")  # Ganti dengan path ke sprite "Tanya"

# Fungsi untuk menyembunyikan tombol jawaban
func hide_answer_buttons():
	button_A.hide()
	button_B.hide()
	button_C.hide()
	button_D.hide()
	mascot_sprite.hide()  # Menyembunyikan sprite maskot
	if timer:  # Hentikan timer jika ada
		timer.stop()

# Deklarasi variabel global
#var timer_duration: float = 5  # Durasi awal timer
#var timer: Timer = null

# Fungsi untuk memulai atau mereset timer
func start_timer():
	# Jika ada timer yang berjalan, hentikan dan hapus timer tersebut
	if timer != null:
		timer.stop()
		remove_child(timer)
	
	# Buat timer baru dengan durasi 5 detik
	timer = Timer.new()
	timer.wait_time = 1  # Setiap 1 detik timer akan timeout
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	timer.one_shot = false  # Timer akan terus berjalan tiap detik
	add_child(timer)
	timer.start()

	_update_timer_label(5)  # Set awal label timer ke 5 detik
	timer_duration = 5  # Set durasi awal ke 5 detik

# Fungsi untuk memperbarui label timer setiap detik
func _update_timer_label(duration: float):
	timer_label.text = str(duration)  # Update label dengan sisa waktu

# Fungsi yang dipanggil setiap kali timer timeout (tiap detik)
func _on_timer_timeout():
	# Kurangi durasi timer
	timer_duration -= 1  
	_update_timer_label(timer_duration)  # Perbarui label timer

	# Jika timer mencapai 0, panggil fungsi waktu habis
	if timer_duration <= 0:
		_on_time_up()

# Fungsi yang dipanggil ketika waktu habis atau soal habis
func _on_time_up():
	feedback_label.text = "Waktu habis!"  # Tampilkan pesan waktu habis
	update_sprite("salah")  # Tampilkan sprite maskot untuk waktu habis (salah)

	## Pindah ke soal berikutnya jika masih ada soal
	#if current_question < questions.size() - 1:
		## Beri jeda sebelum pindah ke soal berikutnya
		#_async_change_question()
	#else:
		## Jika tidak ada soal lagi, pindah ke layar akhir atau game over
	hide_all_elements()
	get_tree().change_scene_to_file("res://gameover_2.tscn")

## Fungsi async untuk menunggu 1.5 detik sebelum pindah soal
#func _async_change_question():
	#await get_tree().create_timer(1.5).timeout  # Tunggu 1.5 detik
	#current_question += 1
	#show_question()  # Tampilkan pertanyaan berikutnya
	#timer_duration = 5  # Reset durasi timer ke 5 detik untuk soal berikutnya
	#start_timer()  # Mulai timer untuk soal berikutnya




# Fungsi yang dijalankan ketika tombol A ditekan
func _on_button_A_pressed():
	selected_answer = "a"
	check_answer()

# Fungsi yang dijalankan ketika tombol B ditekan
func _on_button_B_pressed():
	selected_answer = "b"
	check_answer()

# Fungsi yang dijalankan ketika tombol C ditekan
func _on_button_C_pressed():
	selected_answer = "c"
	check_answer()

# Fungsi yang dijalankan ketika tombol D ditekan
func _on_button_D_pressed():
	selected_answer = "d"
	check_answer()

# Fungsi untuk memeriksa jawaban yang dipilih
func check_answer():
	if selected_answer == correct_answers[current_question]:
		feedback_label.text = "Benar!"
		update_sprite("benar")  # Update sprite ke benar
		#if timer:  # Hentikan timer yang sedang berjalan
			#timer.stop()
		#await get_tree().create_timer(1.0).timeout  # Beri jeda 1 detik sebelum soal berikutnya
		current_question += 1  # Pindah ke soal berikutnya
		show_question()  # Tampilkan soal berikutnya
		start_timer()  # Reset timer untuk soal baru
	else:
		feedback_label.text = "Salah, coba lagi."
		update_sprite("salah")  # Update sprite ke salah

# Fungsi untuk memainkan animasi pertanyaan
func _show_text():
	tofuw_ngomong.label.text = questions[current_question]  # Set teks pertanyaan
	tofuw_ngomong._show_text()  # Tampilkan animasi teks

## Fungsi yang dijalankan ketika tombol Back ditekan
#func _on_button_back_pressed():
	## Aksi ketika tombol Back ditekan (misalnya kembali ke layar sebelumnya)
	#pass  # Implementasi logika untuk kembali ke layar sebelumnya

# Fungsi yang dijalankan ketika tombol Retry ditekan
func _on_button_retry_pressed():
	current_question = 0  # Reset pertanyaan
	randomize_questions()  # Acak ulang pertanyaan
	hide_end_buttons()  # Sembunyikan tombol akhir
	show_question()  # Tampilkan pertanyaan pertama

## Fungsi yang dijalankan ketika tombol Home ditekan
#func _on_button_home_pressed():
	## Aksi ketika tombol Home ditekan (misalnya kembali ke layar utama)
	#pass  # Implementasi logika untuk kembali ke layar utama

# Fungsi untuk menyembunyikan tombol akhir
func hide_end_buttons():
	button_back.hide()
	button_retry.hide()
	button_home.hide()
