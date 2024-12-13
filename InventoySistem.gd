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
		sprite.texture = image_path
		call_deferred("add_child", rigidbody_instance)
