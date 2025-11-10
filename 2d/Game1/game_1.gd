extends Control


@onready var orang_ngomong = $OrangNgomong
@onready var object = $Object

func  _ready():
	if Global.music_b.is_playing():
		pass
	else:	
		Global.play_music_b()
	
