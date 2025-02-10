extends RigidBody3D

@export var ItemTipe : Item

@export var CanvaLayer : CanvasLayer

@export var NameText = Label
@export var LevelText = Label
@export var DescriptionText = Label
# Called when the node enters the scene tree for the first time.
func _ready():
	CanvaLayer.visible = false
	pass # Replace with function body.
	#print(ItemTipe)
	var Name = ItemTipe["Name"]
	var Description = ItemTipe["description"]
	var Level = ItemTipe["level"]
	
	NameText.text = Name
	LevelText.text = str(Level)
	DescriptionText.text = Description


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_area_3d_body_entered(body):
	if is_multiplayer_authority() and body.is_in_group("Player"):
		CanvaLayer.visible = true

func _on_area_3d_body_exited(body):
	if is_multiplayer_authority() and body.is_in_group("Player"):
		CanvaLayer.visible = false
