extends CanvasLayer

var ip = ""
var port = 0

var player_name = "Play Ultrakill"

func _ready() -> void:
	get_parent().remove_child.call_deferred(self)
	get_parent().get_node("Test").add_child.call_deferred(self)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_host_pressed() -> void:
	$HostPanel.visible = true
	$Select.visible = false


func gojoinpress() -> void:
	$Select.visible = false
	$Entered.visible = true

func Accept_Host_Panel() -> void:
	player_name = $User/TextEdit.text 
	var port = int($HostPanel/TextEdit.text)
	$HostPanel.visible = false
	Manager.join_host(port, player_name)
	


func UserNamePress() -> void:
	player_name = $User/TextEdit.text 
	$Select.visible = true
	$User.visible = false
	$Select/name.text = player_name

func AcceptJoin() -> void:
	ip = $Entered/IP.text
	port = int($Entered/PORT.text)
	Manager.JoinServer(ip, port)
	$".".visible = false
