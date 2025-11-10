extends Node

# Referensi ke AudioStreamPlayer
var music_a: AudioStreamPlayer
var music_b: AudioStreamPlayer
var music_c: AudioStreamPlayer
var music_d: AudioStreamPlayer
var music_e: AudioStreamPlayer

# Referensi node dari scene
#@onready var intro = $intro
#@onready var fun_kid = $fun_kid
#@onready var chicken = $chicken
#@onready var o_come_all = $o_come_all
#@onready var funny_gamee_nihh = $funny_gamee_nihh

func _ready():
	# Inisialisasi AudioStreamPlayers
	music_a = AudioStreamPlayer.new()
	music_b = AudioStreamPlayer.new()
	music_c = AudioStreamPlayer.new()
	music_d = AudioStreamPlayer.new()
	music_e = AudioStreamPlayer.new()

	# Memasukkan stream musik
	var intro_stream = preload("res://img/aset/music/intro.mp3")
	var fun_kid_stream = preload("res://img/aset/music/Fun_Kid.mp3")
	var chicken_stream = preload("res://img/aset/music/chicken.mp3")
	var funny_gamee_stream = preload("res://img/aset/music/funny_gamee_nihh.mp3")
	var o_come_all_stream = preload("res://img/aset/music/O_Come_All_Ye_Faithful.mp3")

	music_a.stream = intro_stream
	music_b.stream = fun_kid_stream
	music_c.stream = chicken_stream
	music_d.stream = funny_gamee_stream
	music_e.stream = o_come_all_stream

	# Mengatur looping untuk AudioStream
	intro_stream.loop = true  # Mengatur intro untuk loop
	fun_kid_stream.loop = true  # Mengatur Fun Kid untuk loop (jika diperlukan)
	chicken_stream.loop = true  # Mengatur chicken untuk loop (jika diperlukan)
	funny_gamee_stream.loop = true  # Mengatur funny_gamee_nihh untuk loop (jika diperlukan)
	o_come_all_stream.loop = true  # Mengatur O Come All untuk loop (jika diperlukan)

	# Menambahkan ke scene tree
	add_child(music_a)
	add_child(music_b)
	add_child(music_c)
	add_child(music_d)
	add_child(music_e)

func play_music_a():
	stop_music()
	music_a.play()

func play_music_b():
	stop_music()
	music_b.play()

func play_music_c():
	stop_music()
	music_c.play()

func play_music_d():
	stop_music()
	music_d.play()

func play_music_e():
	stop_music()
	music_e.play()

func stop_music():
	music_a.stop()
	music_b.stop()
	music_c.stop()
	music_d.stop()
	music_e.stop()
