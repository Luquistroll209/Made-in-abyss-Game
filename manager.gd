extends Node3D

var peer = ENetMultiplayerPeer.new()
@export var player : PackedScene
var player_name = "play ultrakil"

func _menu(actived):
	if actived == true:
		$Canva/Select/Host.visible = false
	else:
		$Canva/Select/Join.visible = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func UserNamePress() -> void:
	player_name = $Canva/User/TextEdit.text 
	$Canva/Select.visible = true
	$Canva/User.visible = false
	$Canva/Select/name.text = player_name


func _on_host_pressed() -> void:
	$Canva/HostPanel.visible = true
	$Canva/Select.visible = false


func Accept_HostPanel() -> void:
	var port = int($Canva/HostPanel/TextEdit.text)
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player()
	$Canva/HostPanel.visible = false

	
func _add_player(id = 1):
	var player = player.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)

func gojoinpress() -> void:
	$Canva/Select.visible = false
	$Canva/Entered.visible = true

func AcceptJoin() -> void:
	peer.create_client($Canva/Entered/IP.text, int($Canva/Entered/PORT.text))
	multiplayer.multiplayer_peer = peer
