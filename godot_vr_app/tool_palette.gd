extends Node3D

@export var patient_path: NodePath

@onready var patient: Node = get_node(patient_path)
@onready var liver_button = $LiverButton


func _ready() -> void:
    liver_button.pressed.connect(_on_liver_button_pressed)


func _on_liver_button_pressed() -> void:
    print("Liver button calls patient.toggle_liver()")
    patient.toggle_liver()

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed:
        if event.keycode == KEY_L:
            liver_button.press()
