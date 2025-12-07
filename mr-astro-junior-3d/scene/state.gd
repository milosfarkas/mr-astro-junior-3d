extends Node
class_name GameState

signal open_portal_signal

func open_portal():
	open_portal_signal.emit()
	
