extends Node2D

@export var Inventory : InventoryList
@export var Player : CharacterBody3D

func _ready() -> void:
	if is_multiplayer_authority():
		#get_parent().remove_child.call_deferred(self)
		#get_parent().get_node("Test").add_child.call_deferred(self)
		visible = false
		spawn_sprites()
		
			
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn_sprites():
	if is_multiplayer_authority():
		for item_data in Inventory.InventoryList:
			var item = item_data["ItemModel"]
			var image_path = item_data["TextureIMG"]
			
			
			var rigidbody_scene = load("res://items/item.tscn")
			var rigidbody_instance = rigidbody_scene.instantiate()
			#rigidbody_instance.position = Vector2(0, 100)
			var sprite = rigidbody_instance.get_node("Sprite2D")
			print(rigidbody_instance.initial_rotation)
			rigidbody_instance.ItemTipe = item_data
			sprite.texture = image_path
			call_deferred("add_child", rigidbody_instance)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if is_multiplayer_authority():
		var item_model_path = body.ItemTipe["ItemModelPath"] # Guardamos la ruta de la escena
		var item_type_resource = body.ItemTipe
		var spawn_position = Player.get_node("Spawn").global_transform.origin

		# Llamar RPC para crear el objeto en todos los clientes
		rpc("spawn_item3D", item_model_path, spawn_position, item_type_resource)

		body.queue_free()

@rpc("any_peer", "call_local")
func spawn_item3D(item_model_path: String, position: Vector3, item_type_resource) -> void:
	var item3D_scene = load(item_model_path) # Cargamos la escena usando la ruta
	if item3D_scene:
		var item3D_instance = item3D_scene.instantiate()
		item3D_instance.global_transform.origin = position
		item3D_instance.ItemTipe = item_type_resource
		
		# Agregar al padre adecuado
		var parent_of_parent = get_parent().get_parent()
		parent_of_parent.add_child(item3D_instance)
