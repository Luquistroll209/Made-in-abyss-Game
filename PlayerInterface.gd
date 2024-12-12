extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func Menu(actived):
	if is_multiplayer_authority():
		if actived:
			$Menu.visible = true
		else:
			$Menu.visible = false
func KeyHelp(key, actived):
	if is_multiplayer_authority():
		$Panel/Label.text = key
		if actived:
			$Panel.visible = true
		else:
			$Panel.visible = false
