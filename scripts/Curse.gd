extends Control

@onready var heightText = $Panel/height
@onready var Player = $"../.."
@export var CurseIMG : TextureRect

@onready var last_height = 0
@onready var heightNumber = 0

@export var VomitParticle : GPUParticles3D

func _ready():
	CurseIMG.modulate.a = 0

func _process(delta):
	if is_multiplayer_authority():
		var heightNumber = int(Player.global_position.y)
		heightText.text = str(heightNumber) + "M"
		
		# Layer 1: from 0 to 1350 meters (threshold 50 meters)
		if heightNumber > 0:
			var tween = get_tree().create_tween()
			tween.tween_property(CurseIMG, "modulate:a", 0, 2.0)  # Add Tweener here
		elif heightNumber <= 0 and heightNumber >= -1350:
			CurseIMG.modulate.a = (heightNumber - last_height) / 17 # Change transparency of the CurseIMG node
			if heightNumber - last_height >= 30:
				vomit()
				Player.Hunger -= 10  # Effect of the abyss curse
				last_height = heightNumber  # Update last_height to the current height

		# Layer 2: from 1351 to 2500 meters (threshold 30 meters)
		elif heightNumber >= 1351 and heightNumber <= 2500:
			if Player.global_position.y - 30 >= 1351:
				pass

		# Layer 3: from 2501 to 7000 meters (threshold 20 meters)
		elif heightNumber >= 2501 and heightNumber <= 7000:
			if Player.global_position.y - 20 >= 2501:
				pass

		# Layer 4: from 7001 to 10000 meters (threshold 10 meters)
		elif heightNumber >= 7001 and heightNumber <= 10000:
			if Player.global_position.y - 10 >= 7001:
				pass
				
		if Player.global_position.y < last_height:
			last_height = Player.global_position.y # Update only if the player is descending
			#print(last_height)
			
func vomit():
	VomitParticle.visible = true
	await get_tree().create_timer(5.0).timeout
	VomitParticle.visible = false
