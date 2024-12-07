extends CharacterBody3D

# Sensibilidad del ratón
@export var mouse_sensitivity : float

@export var Name : String

# Velocidad de movimiento del jugador
@export var move_speed : float
@onready var normal_speed = move_speed
@export var run_speed : float


var vertical_angle_limit := 90
# Velocidad de salto
var jump_velocity := 4.5
# Gravedad aplicada
var gravity := -9.8

# Referencia a la cámara
@export var camera : Camera3D
# Referencia al modelo del jugador (el nodo principal que se gira)


# Guardamos las rotaciones actuales
var rotation_x := 0.0
var rotation_y := 0.0

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())  
	if is_multiplayer_authority():
		camera.current = true

func _ready():
	# Bloquear el cursor para que no se salga de la pantalla
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	if is_multiplayer_authority():
		$Label3D.text = Name
		# Obtener el movimiento del ratón
		var mouse_input = Input.get_last_mouse_velocity()

		# Rotación horizontal (girar todo el jugador y la cámara alrededor del eje Y)
		rotation_y -= mouse_input.x * mouse_sensitivity
		rotation_degrees.y = rotation_y # Rotar el modelo del jugador
		
		# Rotación vertical (girar solo la cámara alrededor del eje X)
		rotation_x -= mouse_input.y * mouse_sensitivity
		rotation_x = clamp(rotation_x, -vertical_angle_limit, vertical_angle_limit)
		
		# Aplicar la rotación de la cámara
		camera.rotation_degrees.x = rotation_x

		# Movimiento del jugador con teclas WASD (relativo a la cámara)
		var direction := Vector3.ZERO

		# Obtener la rotación en el eje Y para solo afectar la rotación horizontal
		var camera_transform = camera.global_transform
		var camera_basis = camera_transform.basis
		var forward = -transform.basis.z
		var right = transform.basis.x

		# Verificar las entradas de las teclas WASD
		if Input.is_action_pressed("move_forward"):
			direction += forward
		if Input.is_action_pressed("move_backward"):
			direction -= forward
		if Input.is_action_pressed("move_left"):
			direction -= right
		if Input.is_action_pressed("move_right"):
			direction += right
		if Input.is_action_pressed("run"):
			move_speed = run_speed
			camera.fov + 10
		else:
			move_speed = normal_speed 
			camera.fov - 10

		# Normalizamos para evitar que el movimiento sea más rápido en diagonales
		direction = direction.normalized()

		# Añadir la gravedad
		if not is_on_floor():
			velocity.y += gravity * delta  # Gravedad en el eje Y

		# Salto
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = jump_velocity  # Impulsar hacia arriba

		# Aplicar el movimiento horizontal (X y Z)
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed

		# Mover al jugador (con físicas)
		move_and_slide()
