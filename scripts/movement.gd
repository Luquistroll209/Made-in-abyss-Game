extends CharacterBody3D


@export var mouse_sensitivity : float


@export var maxLive : int #Max live of the player
@export var live : int #Actuali live of the player
@export var maxHunger : int #Max Hunger of the player
@export var Hunger : int #Actuali Hunger of the player
var HungerDecrease = 0


@export var Entered = true 
@export var Playable = true #Uses to menus 

@export var Name : String # Name of player
@export var move_speed : float #Move speed of player
@onready var normal_speed = move_speed 
@export var run_speed : float # run speed

@onready var raycast = $RayCast3D # Raycast uses to see if there are a wall

@onready var CamRaycast = $MeshInstance3D2/Camera3D/RayCast3D 

var vertical_angle_limit := 90 #camera limit

var jump_velocity := 4.5 #Jump

var gravity := -9.8 #Earth gravity

var PoderEscalar = false #if climb or not



@export var camera : Camera3D 

var rotation_x := 0.0
var rotation_y := 0.0


var opened = true 

var menuOpened = false

func _enter_tree() -> void:
	connectJoin()
	set_multiplayer_authority(name.to_int())  
	if is_multiplayer_authority():
		camera.current = true

func _ready():
	if is_multiplayer_authority():
		$UI.Menu(false)
		UpdateLiveAndHunger()
		if Playable:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		global_position = get_parent().get_node("Spawner").global_position
	
	
func UpdateLiveAndHunger():
	if is_multiplayer_authority():
		$UI/Interface/Live/LiveBar.max_value = maxLive
		$UI/Interface/Live/LiveBar.value = live
		$UI/Interface/Hunger/HungerBar.max_value = maxHunger
		$UI/Interface/Hunger/HungerBar.value = Hunger
	
func OpenInventory():
	if is_multiplayer_authority():
		if opened:
			Inventario.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Playable = false
			opened = false
			
		else:
			Inventario.visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Playable = true
			opened = true

func _physics_process(delta):
	if is_multiplayer_authority():
		
		var direction := Vector3.ZERO
		UpdateLiveAndHunger()
		if Playable:
			
			if raycast.is_colliding():
				$UI.KeyHelp("F", true)
				if Input.is_action_pressed("f"):
					PoderEscalar = true
				else:
					PoderEscalar = false
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

			

			var camera_transform = camera.global_transform
			var camera_basis = camera_transform.basis
			var forward = -transform.basis.z
			var right = transform.basis.x
			var up = -transform.basis.y
			
			if Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_backward") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
				pass
			
			if Input.is_action_pressed("move_forward"):
				if PoderEscalar:
					direction -= up
					
				else:
					direction += forward
				
						
					
						
			if Input.is_action_pressed("move_backward"):
				if PoderEscalar:
					direction += up
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
			if Input.is_action_just_pressed("esc"):
				Playable = false
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				$UI.Menu(true)
			if Input.is_action_just_pressed("g"):
					if CamRaycast.is_colliding():
							#var anclaje = $MeshInstance3D2/Camera3D/RayCast3D/Anclaje.instantiate()
							#anclaje.get_node("Test").add_child.call_deferred(self)	
						pass
			if Input.is_action_just_pressed("e"):
				OpenInventory()

					
			if !PoderEscalar: #Cant climb, have gravity if cant climb haven't gravity
				direction = direction.normalized()
				if not is_on_floor():
					velocity.y += gravity * delta  
					# Salto
				if Input.is_action_just_pressed("ui_accept") and is_on_floor():
					velocity.y = jump_velocity  
			else:
				velocity.y = direction.y * move_speed
		else:
			if Input.is_action_just_pressed("esc"):
				Playable = true
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				$UI.Menu(false)
			if Input.is_action_just_pressed("e"):
				OpenInventory()
				
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
		if !PoderEscalar:
				direction = direction.normalized()
				if not is_on_floor():
					velocity.y += gravity * delta  
			
		move_and_slide()
			
func HungerDecreaseFunc():
	if is_multiplayer_authority():
		Hunger -= HungerDecrease
		await get_tree().create_timer(5.0).timeout

func changeName(Player_Name):
	Name = Player_Name
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
