extends CharacterBody3D

@export var mouse_sensitivity: float
@export var maxLive: int
@export var live: int
@export var maxHunger: int
@export var Hunger: int
@export var HungerDecrease: int = 1
@export var Entered = true
@export var Playable = true
@export var Name: String
@export var move_speed: float
@onready var normal_speed = move_speed
@export var run_speed: float
@onready var raycast = $RayCast3D
@onready var raycastItem = $Camera3D/RayCastItem
@onready var CamRaycast = $Camera3D/RayCastItem
@export var camera: Camera3D
@export var Inventory: Node2D

var vertical_angle_limit := 90
var jump_velocity := 4.5
var gravity := -9.8
var PoderEscalar = false
var rotation_x := 0.0
var rotation_y := 0.0
var opened = true
var menuOpened = false
var ItemEntered = false
var ItemObject = null

func _enter_tree() -> void:
	connectJoin()
	set_multiplayer_authority(name.to_int())
	if is_multiplayer_authority():
		camera.current = true

func _ready():
	if is_multiplayer_authority():
		$UI.Menu(false)
		UpdateLiveAndHunger()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if Playable else Input.MOUSE_MODE_VISIBLE)
		global_position = get_parent().get_node("Spawner").global_position
		start_hunger_decrease()

func UpdateLiveAndHunger():
	if is_multiplayer_authority():
		$UI/Interface/Live/LiveBar.max_value = maxLive
		$UI/Interface/Live/LiveBar.value = live
		$UI/Interface/Hunger/HungerBar.max_value = maxHunger
		$UI/Interface/Hunger/HungerBar.value = Hunger

func OpenInventory():
	if is_multiplayer_authority():
		opened = !opened
		$Inventario.visible = opened
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if opened else Input.MOUSE_MODE_CAPTURED)
		Playable = !opened

func _physics_process(delta):
	if is_multiplayer_authority():
		var direction := Vector3.ZERO
		UpdateLiveAndHunger()

		if Playable:
			handle_item_interaction()
			direction = handle_movement(direction)
			handle_camera_rotation()
			handle_special_actions()
		else:
			handle_menu_actions()

		apply_movement(delta, direction)

func handle_item_interaction():
	if ItemEntered:
		$UI.KeyHelp("E", true)
		if Input.is_action_just_pressed("take"):
			Inventory.spawn_sprites(ItemObject.ItemTipe)
			ItemObject.queue_free()
	else:
		$UI.KeyHelp("E", false)

func handle_movement(direction: Vector3) -> Vector3:
	# Verificar si el RayCast detecta una colisión (pared)
	if raycast.is_colliding():
		$UI.KeyHelp("F", true)
		# Activar escalada si se presiona la tecla F
		if Input.is_action_pressed("f"):
			PoderEscalar = true
		else:
			PoderEscalar = false
	else:
		PoderEscalar = false
		$UI.KeyHelp(" ", false)

	# Obtener la dirección del movimiento basada en la entrada del jugador
	if Input.is_action_pressed("move_forward"):
		if PoderEscalar:
			direction.y = 1  # Escalar hacia arriba
		else:
			direction -= transform.basis.z  # Moverse hacia adelante
	if Input.is_action_pressed("move_backward"):
		if PoderEscalar:
			direction.y = -1  # Escalar hacia abajo
		else:
			direction += transform.basis.z  # Moverse hacia atrás
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x  # Moverse hacia la izquierda
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x  # Moverse hacia la derecha

	# Normalizar la dirección para evitar movimiento más rápido en diagonal
	if direction.length() > 0:
		direction = direction.normalized()

	# Aplicar velocidad de carrera o caminata
	move_speed = run_speed if Input.is_action_pressed("run") else normal_speed
	camera.fov = 110 if Input.is_action_pressed("run") else 100

	return direction

func handle_camera_rotation():
	var mouse_input = Input.get_last_mouse_velocity()
	rotation_y -= mouse_input.x * mouse_sensitivity
	rotation_x -= mouse_input.y * mouse_sensitivity
	rotation_x = clamp(rotation_x, -vertical_angle_limit, vertical_angle_limit)
	camera.rotation_degrees.x = rotation_x
	rotation_degrees.y = rotation_y

func handle_special_actions():
	if Input.is_action_just_pressed("esc"):
		toggle_playable_state()
	if Input.is_action_just_pressed("OpenInventory"):
		OpenInventory()

func handle_menu_actions():
	if Input.is_action_just_pressed("esc"):
		toggle_playable_state()
	if Input.is_action_just_pressed("OpenInventory"):
		OpenInventory()

func toggle_playable_state():
	Playable = !Playable
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if Playable else Input.MOUSE_MODE_VISIBLE)
	$UI.Menu(!Playable)

func apply_movement(delta: float, direction: Vector3):
	# Aplicar movimiento horizontal
	velocity.x = direction.x * move_speed
	velocity.z = direction.z * move_speed

	# Aplicar gravedad y salto
	if not PoderEscalar:
		if is_on_floor():
			if Input.is_action_just_pressed("ui_accept"):
				velocity.y = jump_velocity
		else:
			velocity.y += gravity * delta
	else:
		# Movimiento vertical durante la escalada
		velocity.y = direction.y * move_speed

	# Mover al personaje
	move_and_slide()

func start_hunger_decrease():
	while true:
		if is_multiplayer_authority() and Playable and (Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_backward") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or PoderEscalar):
			Hunger = max(Hunger - HungerDecrease, 0)
			UpdateLiveAndHunger()
			if Hunger <= 0:
				live = max(live - 1, 0)
				UpdateLiveAndHunger()
				if live <= 0:
					print("Player has died from starvation!")
		await get_tree().create_timer(5.0).timeout

func _on_area_3d_body_entered(body):
	if body.is_in_group("Item"):
		ItemEntered = true
		ItemObject = body

func _on_area_3d_body_exited(body):
	if body.is_in_group("Item"):
		ItemEntered = false

func takeItem(body):
	pass

func changeName(Player_Name):
	Name = Player_Name

func connectJoin():
	pass
