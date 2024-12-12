extends CharacterBody3D


@export var mouse_sensitivity : float


@export var maxLive : int
@export var live : int

@export var Entered = true
@export var Playable = true

@export var Name : String


@export var move_speed : float
@onready var normal_speed = move_speed
@export var run_speed : float

@onready var raycast = $RayCast3D

var vertical_angle_limit := 90

var jump_velocity := 4.5

var gravity := -9.8

var PoderEscalar = false

@export var camera : Camera3D

var rotation_x := 0.0
var rotation_y := 0.0



func _enter_tree() -> void:
	connectJoin()
	set_multiplayer_authority(name.to_int())  
	if is_multiplayer_authority():
		camera.current = true

func _ready():
	if is_multiplayer_authority():
		$UI.Menu(false)
		UpdateLive()
		if Playable:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
func UpdateLive():
	if is_multiplayer_authority():
		$UI/Interface/Live/LiveBar.max_value = maxLive
		$UI/Interface/Live/LiveBar.value = live
	
func _physics_process(delta):
	if is_multiplayer_authority():
		if Playable:
			if raycast.is_colliding():
				$UI.KeyHelp("F", true)
				if Input.is_action_just_pressed("f"):
					PoderEscalar = true
			else:
				$UI.KeyHelp("F", false)
				PoderEscalar = false
					
			
			$Label3D.text = Name
			var mouse_input = Input.get_last_mouse_velocity()
			rotation_y -= mouse_input.x * mouse_sensitivity
			rotation_degrees.y = rotation_y 
			
			rotation_x -= mouse_input.y * mouse_sensitivity
			rotation_x = clamp(rotation_x, -vertical_angle_limit, vertical_angle_limit)
			
			camera.rotation_degrees.x = rotation_x

			var direction := Vector3.ZERO

			var camera_transform = camera.global_transform
			var camera_basis = camera_transform.basis
			var forward = -transform.basis.z
			var right = transform.basis.x
			var up = -transform.basis.y
			
			if Input.is_action_pressed("move_forward"):
				if PoderEscalar:
					direction += up
					print("arriba")
				else:
					direction += forward
				
					
			if Input.is_action_pressed("move_backward"):
				if PoderEscalar:
					pass
				else:
					direction -= forward
			if Input.is_action_pressed("move_left"):
				direction -= right
			if Input.is_action_pressed("move_right"):
				direction += right
			if Input.is_action_pressed("run"):
				move_speed = run_speed
				camera.fov = 110
			else:
				move_speed = normal_speed 
				camera.fov = 100
			if Input.is_action_pressed("esc"):
				Playable = false
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				$UI.Menu(true)
			direction = direction.normalized()
			if not is_on_floor():
				velocity.y += gravity * delta  
			# Salto
			if Input.is_action_just_pressed("ui_accept") and is_on_floor():
				velocity.y = jump_velocity  

			velocity.x = direction.x * move_speed
			velocity.z = direction.z * move_speed

			move_and_slide()
		else:
			if Input.is_action_pressed("esc"):
				Playable = true
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				$UI.Menu(false)

func connectJoin():
	#var ip = Menu.ip
	#var port = Menu.port
	#var peer = Menu.peer
	#print(Menu.ip)
	#print(port)
	#print(peer)
	#peer.create_client(ip, port)
	#multiplayer.multiplayer_peer = peer
	pass
