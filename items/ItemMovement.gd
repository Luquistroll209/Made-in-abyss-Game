extends RigidBody2D

var holding_click : bool = false

var collision_shape : CollisionShape2D

var initial_mouse_position : Vector2 = Vector2.ZERO

var initial_rotation : float = 0.0

var mouse_offset : Vector2 = Vector2.ZERO
@onready var area_node = get_parent().get_node("StaticBody2D").get_node("Area2D")

@export var ItemTipe = Item.new()

signal click_released(body)
@export var has_exited_area: bool = false
func _ready():

	collision_shape = $Colision

func _input(event):
	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var shape = collision_shape.shape
				var local_position = to_local(event.position)
				
				if shape is RectangleShape2D:
					var rect = shape
					var half_extents = rect.extents
					if local_position.x >= -half_extents.x and local_position.x <= half_extents.x:
						if local_position.y >= -half_extents.y and local_position.y <= half_extents.y:
							holding_click = true
							initial_mouse_position = event.position
							mouse_offset = global_position - event.position
							initial_rotation = rotation
							if event.button_index == MOUSE_BUTTON_WHEEL_UP:
								rotation += deg_to_rad(10)
							elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
								rotation -= deg_to_rad(10)
				"""
				elif shape is CircleShape2D:
					var circle = shape
					var radius = circle.radius
					if local_position.length() <= radius:
						holding_click = true
						initial_mouse_position = event.position
						mouse_offset = global_position - event.position
						initial_rotation = rotation
						print("Clic detectado dentro del círculo")
				"""
				# Puedes agregar más condiciones para otras formas, como PolygonShape2D, etc.
			else:
				holding_click = false
				emit_signal("click_released", self)
# Acción mientras el clic sigue presionado
func _process(delta):
	if holding_click:

		var mouse_position = get_viewport().get_mouse_position()
		global_position = mouse_position + mouse_offset
		

		var direction = (mouse_position - global_position).normalized()
		var target_rotation = direction.angle()
		

		rotation = lerp_angle(rotation, target_rotation, 0.1)
		
