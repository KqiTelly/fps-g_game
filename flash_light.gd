extends Node3D

@onready var spotlight = $SpotLight

func _ready():
	pass
	
	
func shoot():
	if Input.is_action_just_pressed("fire"):
		spotlight.visible = true
		print("flash_light_on")
		
	if Input.is_action_pressed("t"):
		spotlight.visible = false
		print ("flash_light_off")

