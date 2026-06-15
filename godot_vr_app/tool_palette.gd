extends Node3D

@export var patient_path: NodePath
@export var slice_screen_path: NodePath

@onready var patient: Node = get_node(patient_path)
@onready var slice_screen: Node = get_node(slice_screen_path)

@onready var liver_button = $LiverButton
@onready var mass_button = $MassButton
@onready var portal_vein_button = $PortalVeinButton
@onready var aorta_button = $AortaButton
@onready var opacity_button = $OpacityButton
@onready var rotate_left_button = $RotateLeftButton
@onready var rotate_right_button = $RotateRightButton
@onready var reset_button = $ResetButton

@onready var next_slice_button = $NextSliceButton
@onready var previous_slice_button = $PreviousSliceButton
@onready var overlay_button = $OverlayButton


func _ready() -> void:
    liver_button.pressed.connect(_on_liver_button_pressed)
    mass_button.pressed.connect(_on_mass_button_pressed)
    portal_vein_button.pressed.connect(_on_portal_vein_button_pressed)
    aorta_button.pressed.connect(_on_aorta_button_pressed)
    opacity_button.pressed.connect(_on_opacity_button_pressed)
    rotate_left_button.pressed.connect(_on_rotate_left_button_pressed)
    rotate_right_button.pressed.connect(_on_rotate_right_button_pressed)
    reset_button.pressed.connect(_on_reset_button_pressed)
    next_slice_button.pressed.connect(_on_next_slice_button_pressed)
    previous_slice_button.pressed.connect(_on_previous_slice_button_pressed)
    overlay_button.pressed.connect(_on_overlay_button_pressed)


func _on_liver_button_pressed() -> void:
    patient.toggle_liver()


func _on_mass_button_pressed() -> void:
    patient.toggle_mass()


func _on_portal_vein_button_pressed() -> void:
    patient.toggle_portal_vein()


func _on_aorta_button_pressed() -> void:
    patient.toggle_abdominal_aorta()


func _on_opacity_button_pressed() -> void:
    patient.cycle_liver_opacity()


func _on_rotate_left_button_pressed() -> void:
    patient.rotate_left()


func _on_rotate_right_button_pressed() -> void:
    patient.rotate_right()


func _on_reset_button_pressed() -> void:
    patient.reset_view()
    
    
func _on_next_slice_button_pressed() -> void:
    slice_screen.next_view()


func _on_previous_slice_button_pressed() -> void:
    slice_screen.previous_view()


func _on_overlay_button_pressed() -> void:
    slice_screen.toggle_overlay()


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed:
        match event.keycode:
            KEY_L:
                liver_button.press()
            KEY_M:
                mass_button.press()
            KEY_V:
                portal_vein_button.press()
            KEY_A:
                aorta_button.press()
            KEY_O:
                opacity_button.press()
            KEY_Z:
                rotate_left_button.press()
            KEY_X:
                rotate_right_button.press()
            KEY_T:
                reset_button.press()
