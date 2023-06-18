extends CharacterBody3D

var speed 
var Default_speed = 2
var sprint_speed = 3
const ACCEL_DEFAULT = 4
const ACCEL_AIR = 1
@onready var accel = ACCEL_DEFAULT
var gravity = 10
var sensitivity = -0.1
const JUMP_VELOCITY = 4

var d_height = 1.6
var crouch_height = 1.2

var crouch_speed = 20

var mouse_sense = 0.11
var snap

var direction = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()

const ANIM_SMOOTHING_SPEED = 8.0
const FLASHLIGHT_FOLLOW_SPEED = 15.0


#guns
var current_weapon = 1

#bob variables
const BOB_FREQ = 4.0
const BOB_AMP = 0.05
var t_bob = 0.0

#fov variables
const BASE_FOV = 75
const FOV_CHANGE = 1.5

#calls

@onready var head = $neck
@onready var camera = $neck/Camera3D
@onready var pcap = $CollisionShape3D
@onready var ray = $RayCast3D
@onready var gun1 = $neck/Camera3D/hand/weapon/glock1
@onready var flash_light = $flashflight/flash_light
@onready var gun = $neck/Camera3D/hand/glock1
@onready var flashlight_light = $flashflight/flash_light/SpotLight
@onready var anim_tree = $neck/Camera3D/hand/AnimationTree


var anim_blend=0


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		#hides cursor
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	
	#get mouse input for camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sense))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sense))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

	
#gun select
func weapon_select():
	
	if Input.is_action_just_pressed("gun1"):
		current_weapon = 1
	elif Input.is_action_just_pressed("flash_light"):
		current_weapon = 3
		
	if current_weapon == 1:
		gun1.visible = true
		gun1.shoot()
	else:
		gun1.visible = false
	if current_weapon == 3:
		flash_light.visible = true
		flash_light.shoot()
	else:
		flash_light.visible = false



func _physics_process(delta):
	
	make_flashlight_follow(delta)
		
	
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#get keyboard input
	var raying = false
	speed = Default_speed
	direction = Vector3.ZERO
	var h_rot = global_transform.basis.get_euler().y
	var f_input = Input.get_action_strength("down") - Input.get_action_strength("up")
	var h_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	if Input.is_action_pressed("sprint"):

	
	
		speed = sprint_speed
	#jumping and gravity
	if not is_on_floor():
		snap = Vector3.DOWN
		accel = ACCEL_AIR
		velocity.y -= gravity * delta
	else:
		snap = -get_floor_normal()
		accel = ACCEL_DEFAULT
		velocity.y -= JUMP_VELOCITY 
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		snap = Vector3.ZERO
		accel = ACCEL_AIR
		velocity.y = JUMP_VELOCITY 
	#make it move
	velocity = velocity.lerp(direction * speed, accel * delta)
	movement = velocity + gravity_vec
	move_and_slide()
	# crouch func
	if ray.is_colliding():
		raying = true
	if raying:
		pcap.shape.height -= crouch_speed * delta
	elif not raying:
		pcap.shape.height += crouch_speed * delta
	pcap.shape.height =  clamp(pcap.shape.height, crouch_height,d_height)
	if Input.is_action_pressed("crouch"):
		speed = Default_speed
		pcap.shape.height -= crouch_speed * delta
	elif not raying:
		pcap.shape.height += crouch_speed * delta
	pcap.shape.height =  clamp(pcap.shape.height, crouch_height,d_height)
	#walking_shake
	anim_blend = lerpf (anim_blend, direction. length(), delta * ANIM_SMOOTHING_SPEED)
	anim_tree. set ("parameters/blend_position", anim_blend)
	
	weapon_select()
	
	# Head bob
	t_bob += delta * velocity.length() * float (is_on_floor ())
	camera.transform.origin = _headbob (t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, sprint_speed  * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

#light code
func make_flashlight_follow (delta):
	#flash_light.rotation.y = lerp(flash_light .rotation.y, camera.rotation.y, delta * FLASHLIGHT_FOLLOW_SPEED)
	#flash_light.rotation.x = lerp(flash_light .rotation.x, camera.rotation.x, delta * FLASHLIGHT_FOLLOW_SPEED)
	flash_light.rotation.y = lerp(flash_light .rotation.y, head.rotation.y, delta * FLASHLIGHT_FOLLOW_SPEED)
	flash_light.rotation.x = lerp(flash_light .rotation.x, head.rotation.x, delta * FLASHLIGHT_FOLLOW_SPEED)

	

#bop
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
	
	

