extends Node2D

@export var Inventory : InventoryList

func _ready() -> void:
	if is_multiplayer_authority():
		get_parent().remove_child.call_deferred(self)
		get_parent().get_node("Test").add_child.call_deferred(self)
		visible = false

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_multiplayer_authority():
		pass


func spawn_sprites():
	for item_data in Inventory.Item:
		var item = item_data["ItemModel"]
		var image_path = item_data["TextureIMG"]
		
		var rigidbody_scene = load("res://rigidbody_scene.tscn")
		var rigidbody_instance = rigidbody_scene.instance()
		rigidbody_instance.position = Vector2(0, 100)
		get_parent().add_child(rigidbody_instance)
		# Crear el nodo Sprite2D
		var sprite = Sprite2D.new()
		
		# Cargar la imagen y asignarla al sprite
		var texture = load(image_path)  # Cargar la textura desde el archivo de imagen
		sprite.texture = texture  # Asignar la textura al sprite
		
		# Posicionar el sprite en la escena (puedes ajustar la posición como desees)
		
		# Agregar el sprite a la escena
		get_parent().add_child(sprite)  # O usar `add_child(sprite)` si estás en un nodo adecuado

		# Hacer algo más con el 'item' si lo necesitas, como agregar lógica del juego relacionada
		print("Item: ", item, " con imagen: ", image_path)
