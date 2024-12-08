extends CanvasLayer



var peer = ENetMultiplayerPeer.new()
@export var player : PackedScene
var player_name = "play ultrakil"

func _menu(actived):
	if actived == true:
		$Select/Host.visible = false
	else:
		$Select/Join.visible = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func UserNamePress() -> void:
	player_name = $User/TextEdit.text 
	$Select.visible = true
	$User.visible = false
	$Select/name.text = player_name


func _on_host_pressed() -> void:
	$HostPanel.visible = true
	$Select.visible = false



func Accept_HostPanel() -> void:
	var port = int($HostPanel/TextEdit.text)
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player()
	$HostPanel.visible = false
	get_tree().root.add_child(preload("res://test.tscn").instantiate())


	
func _add_player(id = 1):
	var player = player.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)

func gojoinpress() -> void:
	$Select.visible = false
	$Entered.visible = true

func AcceptJoin() -> void:
	# Instanciar la escena MultiplayerSpawner
	var multiplayer_spawner_scene = preload("res://test.tscn")
	var multiplayer_spawner_instance = multiplayer_spawner_scene.instantiate()

	# Añadir el MultiplayerSpawner a la escena principal
	get_tree().root.add_child(multiplayer_spawner_instance)

	# Acceder al nodo MultiplayerSpawner y modificar sus propiedades
	multiplayer_spawner_instance.spawn_path = "res://test.tscn"
