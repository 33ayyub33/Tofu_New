extends Node2D

# Tombol hapus dan ulang, pastikan nama-nama node sesuai
@onready var hapus_garis = $MarginContainer/VBoxContainer/penting/hapus
@onready var ulang_garis = $MarginContainer/VBoxContainer/penting/ulang
@onready var label_soal = $MarginContainer/VBoxContainer/penting/Label  # Mengacu pada Label yang menampilkan soal

var word_to_guess = "HELLO"  # Kata yang harus ditebak
var current_letter_index = 0  # Index huruf saat ini
var drawing = false  # Apakah sedang menggambar
var points = []  # Penyimpanan untuk posisi garis
var dash_pattern = []  # Pola titik-titik huruf yang diinginkan

# Fungsi untuk menghasilkan pola titik-titik dari kata yang harus ditebak
func generate_dash_pattern():
	dash_pattern.clear()
	var start_x = 50
	var start_y = 50
	for letter in word_to_guess:
		# Menggambar huruf sebagai pola titik-titik
		dash_pattern.append(Vector2(start_x, start_y))
		start_x += 100  # Menjaga jarak antar huruf

# Fungsi untuk menangani input pengguna
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			drawing = event.pressed
			if drawing:
				points.append([event.position])

	if event is InputEventMouseMotion and drawing:
		points[-1].append(event.position)
		queue_redraw()  # Menggambar ulang canvas saat ada gerakan

# Fungsi menggambar di layar
func _draw():
	# Gambar pola titik-titik (misalnya untuk huruf saat ini)
	draw_dotted_line(dash_pattern)
	
	# Gambar garis yang digambar pengguna
	for stroke in points:
		if stroke.size() > 1:
			for i in range(stroke.size() - 1):
				draw_line(stroke[i], stroke[i + 1], Color(1, 0, 0), 3)

# Fungsi untuk menggambar pola titik-titik huruf
func draw_dotted_line(pattern):
	for i in range(pattern.size() - 1):
		draw_line(pattern[i], pattern[i + 1], Color(0, 1, 0), 3, true)

# Fungsi untuk verifikasi apakah huruf yang ditulis pengguna sesuai dengan pola titik-titik
func check_answer():
	# Logika sederhana untuk mengecek apakah huruf yang digambar sesuai
	if points.size() > 0:
		# Bandingkan dengan pola titik-titik huruf yang diharapkan
		if is_correct(points, dash_pattern):
			print("Huruf benar!")
			current_letter_index += 1  # Pindah ke huruf berikutnya
		else:
			print("Huruf salah, coba lagi.")
	else:
		print("Tidak ada gambar")

# Fungsi sederhana untuk mengecek apakah gambar sesuai dengan pola
func is_correct(drawn_points, pattern):
	# Kamu bisa tambahkan logika yang lebih kompleks, misalnya dengan threshold jarak antara garis yang digambar dan pola
	return drawn_points.size() > 0

# Fungsi untuk membersihkan semua gambar
func clear_canvas():
	points.clear()
	queue_redraw()

# Fungsi untuk hapus gambar terakhir
func undo_last_stroke():
	if points.size() > 0:
		print("Menghapus garis terakhir")
		points.pop_back()
		queue_redraw()
	else:
		print("Tidak ada garis yang dapat dihapus")

# Fungsi yang dipanggil saat game dimulai
func _ready():
	# Menghasilkan pola titik-titik dari kata yang harus ditebak
	generate_dash_pattern()

	# Mengatur label kata yang harus ditebak
	label_soal.text = "Tebak kata: %s" % word_to_guess
	#label_soal.set("custom_fonts/font", load("res://path/to/your/font.tres"))  # Pastikan Anda menggunakan font yang besar

	# Pastikan tombol hapus dan ulang terhubung
	#hapus_garis.connect("pressed", Callable(self, "_on_hapus_pressed"))
	#ulang_garis.connect("pressed", Callable(self, "_on_ulang_pressed"))

# Fungsi yang dipanggil saat tombol hapus ditekan
func _on_hapus_pressed():
	print("Tombol hapus ditekan")
	undo_last_stroke()
	
# Fungsi yang dipanggil saat tombol ulang ditekan
func _on_ulang_pressed():
	print("Tombol ulang ditekan")
	clear_canvas()


func _on_keluar_2_1_pressed():
	get_tree().change_scene_to_file("res://piilih_game.tscn")
