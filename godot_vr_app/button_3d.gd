extends Area3D

signal pressed

@export var label_text: String = "Button"

@onready var label: Label3D = $Label3D


func _ready() -> void:
	label.text = label_text


func press() -> void:
	print("Button pressed: ", label_text)
	pressed.emit()
