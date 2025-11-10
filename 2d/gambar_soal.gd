extends TextureRect  # Menggunakan TextureRect sebagai node utama

var image_paths = [
	"res://img/aset/game_2/apel_mangga.png",
	"res://img/aset/game_2/baca_buku.png",
	"res://img/aset/game_2/bli_buku.png",
	"res://img/aset/game_2/bli_tofu.png",
	"res://img/aset/game_2/num_cucu.png",
	"res://img/aset/game_2/nyapu.png"
]

var current_question = 0

func _ready():
	# Mengatur mode gambar untuk menjaga rasio dan menempatkannya di tengah
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	# Jika kamu ingin mengatur ukuran minimum dari gambar
	custom_minimum_size = Vector2(300, 300)  # Sesuaikan ukuran minimum (misalnya 300x300)
	
	show_image_for_question(current_question)

# Fungsi untuk menampilkan gambar sesuai dengan soal
func show_image_for_question(question_index: int):
	if question_index >= 0 and question_index < image_paths.size():
		var image_texture = load(image_paths[question_index])
		
		if image_texture:  # Validasi apakah texture berhasil di-load
			self.texture = image_texture  # Set texture langsung ke TextureRect
		else:
			print("Gambar tidak ditemukan atau gagal di-load: ", image_paths[question_index])
	else:
		print("Index soal tidak valid: ", question_index)
