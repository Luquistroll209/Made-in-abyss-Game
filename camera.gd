extends Camera3D

# Sensibilidad del ratón
var mouse_sensitivity := 0.003
# Limite para la rotación vertical (para evitar girar 360 grados)
var vertical_gle_limit := 90.0

# Guardamos las rotaciones actuales
var rotation_x := 0.0
var rotation_y := 0.0

func _ready():
	# Bloquear el cursor cuando la cámara empiece a moverse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	# Obtener el movimiento del ratón
	var mouse_input = Input.get_last_mouse_velocity()

	# Rotación horizontal (girar la cámara alrededor del eje Y)
	rotation_y -= mouse_input.x * mouse_sensitivity
	# Rotación vertical (girar la cámara alrededor del eje X)
	rotation_x -= mouse_input.y * mouse_sensitivity
	rotation_x = clamp(rotation_x, -vertical_angle_limit, vertical_angle_limit)
	
	# Aplicar la rotación
	rotation_degrees = Vector3(rotation_x, rotation_y, 0)
