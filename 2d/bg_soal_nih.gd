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



# Daftar jalur gambar yang sesuai dengan pertanyaan
var question_image_map = [
	"res://img/aset/game_2/SOAL/I_baca.png",
	"res://img/aset/game_2/SOAL/I_memeluk.png",
	"res://img/aset/game_2/SOAL/I_belanja.png",
	"res://img/aset/game_2/SOAL/I_beljar.png",
	"res://img/aset/game_2/SOAL/I_cuci_pring.png",
	"res://img/aset/game_2/SOAL/I_masak.png",
	"res://img/aset/game_2/SOAL/I_menggendong.png",
	"res://img/aset/game_2/SOAL/I_menjemur.png",
	"res://img/aset/game_2/SOAL/I_sapu.png"
]

# Daftar pertanyaan dan pilihan jawaban
var questions = [
	"Halo dek apa yang sedang ibu lakukan?"
]

var pilihan_jawab = [
	["mem", "ca" , "bu", "ba"],
	["je", "men" , "me", "luk"],
	["ja", "ber" , "lan", "be"],
	["jar", "la" , "ra", "be"],
	["cu", "ca" , "ci", "men"],
	["sak", "mam" , "me", "ma"],
	["mem", "ca" , "bu", "ba"],
	["ja", "mur" , "je", "men"],
	["je", "men" , "mur", "mam"],
	["sa", "nya" , "pu", "me"]
]

# Jawaban yang benar untuk setiap soal (indeks mengikuti urutan pertanyaan yang tidak diacak)
var correct_answers = ["mem" + "ba" + "ca", "men" + "je" + "mur", "c", "a", "c", "a"]

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
		shuffled_pilihan.append(pilihan_jawab[index])
		shuffled_answers.append(correct_answers[index])

	questions = shuffled_questions
	question_image_map = shuffled_images
	pilihan_jawab = shuffled_pilihan
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

		get_tree().change_scene_to_file("res://gameover_2.tscn")




# Fungsi untuk memperbarui pilihan jawaban sesuai dengan soal yang ditampilkan
func update_answers(index):
	button_A.text = pilihan_jawab[index][0]
	button_B.text = pilihan_jawab[index][1]
	button_C.text = pilihan_jawab[index][2]
	button_D.text = pilihan_jawab[index][3]
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


	get_tree().change_scene_to_file("res://gameover_2.tscn")






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
		update_sprite("benar")  
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



# Fungsi yang dijalankan ketika tombol Retry ditekan
func _on_button_retry_pressed():
	current_question = 0  # Reset pertanyaan
	randomize_questions()  # Acak ulang pertanyaan
	show_question()  # Tampilkan pertanyaan pertama
