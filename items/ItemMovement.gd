extends RigidBody2D

# Variable para controlar si se está manteniendo el clic
var holding_click : bool = false

# Referencia al CollisionShape2D
var collision_shape : CollisionShape2D

# Variable para almacenar la posición inicial del ratón
var initial_mouse_position : Vector2 = Vector2.ZERO

# Variable para almacenar la rotación inicial del nodo
var initial_rotation : float = 0.0


# Variable para almacenar el desplazamiento inicial (para movimiento)
var mouse_offset : Vector2 = Vector2.ZERO
@onready var area_node = get_parent().get_node("StaticBody2D").get_node("Area2D")

@export var ItemTipe = Item.new()


func _ready():
	# Obtener la referencia al CollisionShape2D (debe estar en el mismo nodo que este script)
	collision_shape = $Colision

# Detectar la entrada del ratón
func _input(event):
	if event is InputEventMouseButton:
		# Si el botón izquierdo del mouse es presionado
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Obtener el tipo de la forma del CollisionShape2D
				var shape = collision_shape.shape
				var local_position = to_local(event.position)
				
				if shape is RectangleShape2D:
					# Detectar si el clic está dentro del rectángulo
					var rect = shape
					var half_extents = rect.extents
					if local_position.x >= -half_extents.x and local_position.x <= half_extents.x:
						if local_position.y >= -half_extents.y and local_position.y <= half_extents.y:
							holding_click = true
							initial_mouse_position = event.position
							mouse_offset = global_position - event.position
							initial_rotation = rotation
							print("Clic detectado dentro del rectángulo")
				
				elif shape is CircleShape2D:
					# Detectar si el clic está dentro del círculo
					var circle = shape
					var radius = circle.radius
					if local_position.length() <= radius:
						holding_click = true
						initial_mouse_position = event.position
						mouse_offset = global_position - event.position
						initial_rotation = rotation
						print("Clic detectado dentro del círculo")
				
				# Puedes agregar más condiciones para otras formas, como PolygonShape2D, etc.
			else:
				holding_click = false
				print("Clic liberado")

# Acción mientras el clic sigue presionado
func _process(delta):
	if holding_click:
		# Mover el nodo con el ratón (utilizando el desplazamiento inicial para evitar el salto)
		var mouse_position = get_viewport().get_mouse_position()
		global_position = mouse_position + mouse_offset
		
		# Calcular el ángulo de rotación hacia el ratón
		var direction = (mouse_position - global_position).normalized()
		var target_rotation = direction.angle()
		
		# Rotar suavemente hacia la dirección del ratón
		rotation = lerp_angle(rotation, target_rotation, 0.1)
		
