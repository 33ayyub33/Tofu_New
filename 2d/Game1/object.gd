extends Control

var jeruk: int
var semangka: int
var apel: int
var nanas: int

func _process(_delta):
	%Nanas.text = "nanas"+str(nanas)
	%Semangka.text = "semangka"+str(semangka)
	%Apel.text = "apel"+str(apel)
	%Jeruk.text = "jeruk"+str(jeruk)
func _on_jeruk_pressed():
	jeruk += 1


func _on_semangka_pressed():
	semangka += 1


func _on_apel_pressed():
	apel += 1


func _on_nanas_pressed():
	nanas += 1



func _on_keluar_2_pressed():
	get_tree().change_scene_to_file("res://piilih_game.tscn")
