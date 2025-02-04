extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_multiplayer_authority():
		visible = true

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
			print("activated" + key)
		else:
			$Panel.visible = false
