extends Node
class_name GameState

signal open_portal_signal

func open_portal():
	print("emitting open portal in GameState")
	open_portal_signal.emit()
	
