extends Control

@onready var heightText = $Panel/height
@onready var Player = $"../.."

@onready var heightNumber

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	heightNumber = int(Player.global_position.y)
	heightText = str(heightNumber) + "M"
