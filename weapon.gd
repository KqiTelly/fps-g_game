extends Node3D

@onready var AnimePlayer = $AnimationPlayer

func _ready():
	pass
	

func shoot():
	if Input.is_action_just_pressed("Relode"):
		AnimePlayer.play ("rolode")
		AnimePlayer.play ("shake")
		print ("reloading")
