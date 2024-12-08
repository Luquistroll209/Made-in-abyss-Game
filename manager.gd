extends CanvasLayer

var ip = ""
var port = 0

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



	
func _add_player(id = 1):
	var player = player.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)

func gojoinpress() -> void:
	$Select.visible = false
	$Entered.visible = true

func AcceptJoin() -> void:
	ip = $Entered/IP.text
	port = int($Entered/PORT.text)
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer
	await get_tree().create_timer(1).timeout
	#get_tree().root.add_child(preload("res://test.tscn").instantiate())
	#await get_tree().create_timer(0).timeout
	#get_parent().queue_free()
