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
