extends Node3D

@onready var AnimPlayer = $Animations
@onready var sound = $shot
@export var damage : int

@export var ammo : int
@export var max_ammo : int
@export var spare_ammo :int 

@export var ammo_per_shot : int 
@export var inf_spare_ammo : bool

@export var full_auto : bool

@export var reload_time : float
@export var firerate : float

@export var rayCast : NodePath
@onready var raycast = get_node(rayCast)

var can_shoot = true
var reloading = false
var paused = false

func _ready():
	pass
	randomize()
	
func shoot():
	if Input.is_action_just_pressed("fire"):
		AnimPlayer.play("kick") 
		
		sound.set_pitch_scale(randf_range(.7, .9))
		print("gun1_fired")
	










