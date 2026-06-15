extends Node3D

@export var slice_screen_path: NodePath
@export var title_label_path: NodePath

@export var axial_plain: Texture2D
@export var axial_overlay: Texture2D
@export var coronal_plain: Texture2D
@export var coronal_overlay: Texture2D
@export var sagittal_plain: Texture2D
@export var sagittal_overlay: Texture2D

@onready var slice_screen: MeshInstance3D = get_node(slice_screen_path)
@onready var title_label: Label3D = get_node(title_label_path)

var current_view_index := 0
var overlay_enabled := true

var views := []


func _ready() -> void:
    views = [
        {
            "name": "Axial CT slice",
            "plain": axial_plain,
            "overlay": axial_overlay
        },
        {
            "name": "Coronal CT slice",
            "plain": coronal_plain,
            "overlay": coronal_overlay
        },
        {
            "name": "Sagittal CT slice",
            "plain": sagittal_plain,
            "overlay": sagittal_overlay
        }
    ]

    update_slice_screen()


func next_view() -> void:
    current_view_index = (current_view_index + 1) % views.size()
    update_slice_screen()


func previous_view() -> void:
    current_view_index = (current_view_index - 1 + views.size()) % views.size()
    update_slice_screen()


func toggle_overlay() -> void:
    overlay_enabled = not overlay_enabled
    update_slice_screen()


func update_slice_screen() -> void:
    var current_view = views[current_view_index]

    var texture: Texture2D
    if overlay_enabled:
        texture = current_view["overlay"]
    else:
        texture = current_view["plain"]

    set_screen_texture(texture)

    var overlay_text := "overlay ON" if overlay_enabled else "overlay OFF"
    title_label.text = current_view["name"] + " | " + overlay_text


func set_screen_texture(texture: Texture2D) -> void:
    if texture == null:
        push_warning("Slice texture is null.")
        return

    var mat := StandardMaterial3D.new()
    mat.albedo_texture = texture
    mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED

    slice_screen.material_override = mat

    print("Changed slice texture to: ", texture.resource_path)


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed:
        match event.keycode:
            KEY_N:
                next_view()
            KEY_B:
                previous_view()
            KEY_Y:
                toggle_overlay()
