extends RigidBody3D

@export var ItemTipe : Item

@export var NameText = Label
@export var LevelText = Label
@export var DescriptionText = Label

# Called when the node enters the scene tree for the first time.
func _ready():
	#print(ItemTipe)
	var Name = ItemTipe["Name"]
	var Description = ItemTipe["description"]
	var Level = ItemTipe["level"]
	
	NameText.text = Name
	LevelText.text = str(Level)
	DescriptionText.text = Description


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
