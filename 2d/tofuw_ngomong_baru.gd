extends Control

@onready var label = $Label
@onready var anim_show = $AnimationPlayer

# Fungsi untuk menampilkan animasi teks
func _show_text():
	anim_show.play("tofuw_ngomong_game2")  # Memainkan animasi
