extends Node

var ip = ""
var port = 0

@onready var peer = ENetMultiplayerPeer.new()
@export var player : PackedScene
var player_name = "play ultrakil"

func _menu(actived):
	if actived == true:
		$Select/Host.visible = false
	else:
		$Select/Join.visible = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().remove_child.call_deferred(self)
	get_parent().get_node("Test").add_child.call_deferred(self)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _add_player(id, player_name):
	var player = player.instantiate()
	player.name = str(id)
<<<<<<< HEAD
	#player.changeName(player_name)
=======
	player.changeName(player_name)
>>>>>>> 28dacb6f3db80d8dccb6fa43f7ba36977bdbf3a8
	#get_parent().get_node("Test").call_deferred("add_child", player)
	get_parent().call_deferred("add_child", player)

func join_host(portHost, player_name):
	get_tree().root.add_child(preload("res://test.tscn").instantiate())
	peer.create_server(portHost)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player(1, player_name)
	

func JoinServer(ip, port):
	peer.create_client(ip, port)
	#await get_tree().create_timer(1).timeout
	multiplayer.multiplayer_peer = peer
