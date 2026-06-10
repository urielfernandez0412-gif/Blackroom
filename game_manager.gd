extends Node

const PUERTO = 19000
const MAX_JUGADORES = 4

var peer = ENetMultiplayerPeer.new()

func crear_partida():
	peer.create_server(PUERTO, MAX_JUGADORES)
	multiplayer.multiplayer_peer = peer
	print("Servidor creado en puerto ", PUERTO, " IP: ", get_ip_local())

	multiplayer.peer_connected.connect(_on_player_connected)
func unirse_partida(ip: String):
	peer.create_client(ip, PUERTO)
	multiplayer.multiplayer_peer = peer
	print("Conectando a ", ip, ":", PUERTO)
										
func _on_player_connected(id):
	print("Jugador conectado: ", id)

func cambiar_nivel(nivel_id: int):
	var ruta = "res://niveles/%d/nivel_%d.tscn" % [nivel_id, nivel_id]
	print("cargando: ", ruta)
	if multiplayer.is_server():
		cambiar_nivel_para_todos.rpc(ruta)
		
@rpc("authority", "call_local")
func cambiar_nivel_para_todos(ruta: String):
	get_tree().change_scene_to_file(ruta)
	
func get_ip_local():
	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168."):
			return ip
		
