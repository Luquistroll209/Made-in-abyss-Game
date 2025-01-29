extends Node2D

@export var Inventory : InventoryList

func _ready() -> void:
	if is_multiplayer_authority():
		get_parent().remove_child.call_deferred(self)
		get_parent().get_node("Test").add_child.call_deferred(self)
		visible = false
		spawn_sprites()

		
			
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn_sprites():
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
	#var model = body.ItemTipe.ItemModel.instantiate()
	#model.get_parent().remove_child.call_deferred(body)
	#print(model.get_parent().get_parent().get_node("Test").add_child.call_deferred(self))
	
	#body.get_parent().get_node("Test").call_deferred("add_child", model)
	#body.queue_free()
	#call_deferred("add_child", model)
	#print(model.get_path())
	pass
