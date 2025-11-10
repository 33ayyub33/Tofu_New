extends Node2D

# Node references
@onready var hapus_garis = $MarginContainer/VBoxContainer/penting/hapus_garis
@onready var ulang_garis = $MarginContainer/VBoxContainer/penting/undo
@onready var ceklist_button =$MarginContainer/VBoxContainer/penting/ceklist
@onready var label_soal = $MarginContainer/VBoxContainer/penting/papan_huruf/Label
@onready var papan_jawaban = $MarginContainer/VBoxContainer/penting/papan_jawabn/SOAL
@onready var tanya = $Tanya
@onready var label_chat = $gelembung_chat/Label

# Variabel dan urutan soal
var gambar_huruf = [
	"res://img/aset/game_3/m.png",
	"res://img/aset/game_3/a.png",
	"res://img/aset/game_3/k.png",
	"res://img/aset/game_3/a.png",
	"res://img/aset/game_3/n.png"
]

var current_huruf_index = 0
var garis_dibuat = []
var is_drawing = false
var current_line = null  # Track the current line being drawn
var finished_huruf_count = 0  # Menghitung huruf yang sudah digambar dengan benar

# Fungsi untuk memulai menggambar
func _ready():
	if Global.music_c.is_playing():
		pass
	else:	
		Global.play_music_c()
	label_soal.text = "MAKAN"  # Soal yang ditampilkan
	set_process_input(true)  # Enable input processing
	_show_next_huruf()
	ceklist_button.hide()  # Hide the checklist button initially

func _input(event):
	# Menangani input dari layar sentuh
	if event is InputEventScreenTouch and event.pressed and not is_drawing:
		is_drawing = true
		current_line = Line2D.new()
		current_line.width = 30  # Set the line width for touch
		current_line.default_color = Color(1, 0, 0)  # Set the line color to red
		current_line.add_point(event.position)  # Start the line at touch position
		add_child(current_line)  # Add the line to Node2D directly
		garis_dibuat.append(current_line)
		

	elif event is InputEventScreenTouch and not event.pressed and is_drawing:
		# Selesai menggambar
		is_drawing = false

	# Menangani input dari mouse
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and not is_drawing:
			is_drawing = true
			current_line = Line2D.new()
			current_line.width = 30  # Set the line width for mouse
			current_line.default_color = Color(1, 0, 0)  # Set the line color to red
			current_line.add_point(event.position)  # Start the line at mouse position
			add_child(current_line)  # Add the line to Node2D directly
			garis_dibuat.append(current_line)
			ceklist_button.show()  # Show checklist button when drawing starts

		elif not event.pressed and is_drawing:
			# Selesai menggambar dengan mouse
			is_drawing = false

	# Menangani input saat pengguna menyeret (drag) di layar atau dengan mouse
	if event is InputEventScreenDrag and is_drawing:
		current_line.add_point(event.position)  # Add point as user drags
	elif event is InputEventMouseMotion and is_drawing:
		current_line.add_point(event.position)  # Add point as user drags with mouse

# Menampilkan huruf yang harus digambar
func _show_next_huruf():
	if current_huruf_index < gambar_huruf.size():
		var huruf_image = load(gambar_huruf[current_huruf_index])
		papan_jawaban.texture = huruf_image  # Tampilkan gambar huruf di papan_jawaban
	else:
		# Jika semua huruf sudah benar tergambar, pindah ke scene berikutnya
		get_tree().change_scene_to_file("res://tres/game_3_pilih_soal.tscn")

## Fungsi untuk mengecek apakah huruf digambar dengan benar
#func _check_huruf_benar():
	## Cek apakah gambar sesuai dengan pola
	#if is_huruf_benar():
		#print("Huruf benar!")
		#finished_huruf_count += 1  # Tambah jumlah huruf yang sudah digambar
		#current_huruf_index += 1
		#_show_next_huruf()
	#else:
		#print("Huruf salah, coba lagi.")
#
#func is_huruf_benar() -> bool:
	## Ambil gambar huruf yang benar untuk perbandingan
	#var correct_huruf_texture = load(gambar_huruf[current_huruf_index])
#
	## Cek apakah tekstur yang dimuat adalah ImageTexture
	#if correct_huruf_texture is ImageTexture:
		#var correct_huruf_image = correct_huruf_texture.get_data()  # Mendapatkan data Image dari Texture
		#correct_huruf_image.lock()  # Mengunci gambar untuk akses
#
		#var drawn_image = Image.new()
		#drawn_image.create(correct_huruf_image.get_width(), correct_huruf_image.get_height(), false, Image.FORMAT_RGBA8)  # Create with the same size
		#drawn_image.lock()
#
		## Menggambar setiap garis ke dalam drawn_image
		#for garis in garis_dibuat:
			#for i in range(garis.get_point_count() - 1):
				#drawn_image.draw_line(garis.get_point(i), garis.get_point(i + 1), Color(1, 0, 0))
#
		#drawn_image.unlock()
		#correct_huruf_image.unlock()
#
		## Bandingkan pixel
		#return compare_images(correct_huruf_image, drawn_image)
	#else:
		#print("Gambar tidak valid! Pastikan format gambar benar.")  # Menangani kasus jika gambar tidak dapat dimuat
		#return false
#
## Fungsi untuk membandingkan dua gambar dengan toleransi
#func colors_match(color_a: Color, color_b: Color, tolerance: float = 0.1) -> bool:
	#return abs(color_a.r - color_b.r) <= tolerance and abs(color_a.g - color_b.g) <= tolerance and abs(color_a.b - color_b.b) <= tolerance and abs(color_a.a - color_b.a) <= tolerance
#
## Fungsi untuk membandingkan dua gambar
#func compare_images(image_a: Image, image_b: Image) -> bool:
	#if image_a.get_width() != image_b.get_width() or image_a.get_height() != image_b.get_height():
		#print("Images have different sizes!")  # Debugging line
		#return false
#
	## Perbandingan pixel dengan toleransi
	#for x in range(image_a.get_width()):
		#for y in range(image_a.get_height()):
			#if not colors_match(image_a.get_pixel(x, y), image_b.get_pixel(x, y)):
				#print("Mismatch at pixel: ", x, ", ", y)  # Debugging line
				#return false  # Ada perbedaan pixel
#
	#return true  # Semua pixel sama

# Fungsi untuk menghapus garis terakhir yang digambar
func _on_hapus_garis_pressed():
	for garis in garis_dibuat:
		garis.queue_free()
	garis_dibuat.clear()
	ceklist_button.hide()  # Hide the checklist button after clearing
	_show_next_huruf()

# Fungsi untuk mengulang menggambar huruf saat ini
func _on_ulang_garis_pressed():
	if garis_dibuat.size() > 0:
		var garis_terakhir = garis_dibuat.pop_back()
		garis_terakhir.queue_free()

func _lanjut():
	# Cek apakah gambar sesuai dengan pola
	print("Huruf selanjutnya!")
	for garis in garis_dibuat:
		garis.queue_free()
	finished_huruf_count += 1  # Tambah jumlah huruf yang sudah digambar
	current_huruf_index += 1
	_show_next_huruf()
		
# Fungsi keluar dari scene
func _on_keluar_2_1_pressed():
	get_tree().change_scene_to_file("res://tres/game_3_pilih_soal.tscn")

# Fungsi untuk menangani klik pada tombol ceklist
func _on_ceklist_pressed():
	if  gambar_huruf.size() == current_huruf_index + 1: 
		get_tree().change_scene_to_file("res://tres/game_3_pilih_soal.tscn")
	else :
		#garis_dibuat.size() > 0  :  # Check if the user has drawn something
		_lanjut()  # Check the drawn letter
		garis_dibuat.clear()  # Clear the drawn lines after checking
		ceklist_button.hide()  # Hide the checklist button after pressing
		

		
