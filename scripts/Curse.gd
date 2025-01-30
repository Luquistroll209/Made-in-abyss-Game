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
		var tween = get_tree().create_tween()
		# Capa 1: de 0 a 1350 metros (umbral 50 metros)
		if heightNumber > 0:
			tween.tween_property(CurseIMG, "modulate:a", 0, 2.0)
		elif heightNumber <= 0 and heightNumber >= -1350:
			CurseIMG.modulate.a = (heightNumber - last_height) / 17 #Change transparency of the node CurseIMG
			if heightNumber - last_height >= 30:
				vomit()
				Player.Hunger -= 10  #Efect of de curse of abyss
				last_height = heightNumber  # Update de last_height to actual last height
			

		# Capa 2: de 1351 a 2500 metros (umbral 30 metros)
		elif heightNumber >= 1351 and heightNumber <= 2500:
			if Player.global_position.y - 30 >= 1351:
				pass

		# Capa 3: de 2501 a 7000 metros (umbral 20 metros)
		elif heightNumber >= 2501 and heightNumber <= 7000:
			if Player.global_position.y - 20 >= 2501:
				pass

		# Capa 4: de 7001 a 10000 metros (umbral 10 metros)
		elif heightNumber >= 7001 and heightNumber <= 10000:
			if Player.global_position.y - 10 >= 7001:
				pass
				
		if Player.global_position.y < last_height:
			last_height = Player.global_position.y # Actualizamos solo si el jugador está bajando
			#print(last_height)
			
func vomit():
		VomitParticle.visible = true
		await get_tree().create_timer(5.0).timeout
		VomitParticle.visible = false
