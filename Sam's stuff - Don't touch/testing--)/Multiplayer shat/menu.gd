extends Control

const PORT = 6501
const IP_ADRESS = "localhost"

func _on_host_button_pressed() -> void:
	print("hosting. . .")
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	start_game()

func start_game():
	pass

func _on_join_button_pressed() -> void:
	print("joining ")
