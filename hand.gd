extends Node3D

const ADS_LERP = 20

@export var camera_path : NodePath
var camera  :Camera3D

@export var default_position : Vector3
@export var ads_position : Vector3
var fview = {"Default": 60, "ADS": 50}

func _ready():
	camera = get_node(camera_path)
	pass
func _process(delta):
	
	
	if Input.is_action_pressed("aim"):
		transform.origin = transform.origin.lerp(ads_position, ADS_LERP * delta)
		camera.fov = lerpf (camera.fov, fview["ADS"], ADS_LERP * delta)
	else:
		transform.origin = transform.origin.lerp(default_position, ADS_LERP * delta)
		camera.fov = lerpf (camera.fov, fview["Default"], ADS_LERP * delta)
