extends Node3D

@onready var patient_pivot: Node3D = $PatientPivot
@onready var model_root: Node3D = $PatientPivot/ModelRoot

@onready var liver: Node3D = $PatientPivot/ModelRoot/liver_blended
@onready var mass: Node3D = $PatientPivot/ModelRoot/mass_blended
@onready var portal_vein: Node3D = $PatientPivot/ModelRoot/portal_vein_blended
@onready var abdominal_aorta: Node3D = $PatientPivot/ModelRoot/abdominal_aorta_blended

var liver_opacity_levels := [0.20, 0.40, 0.70, 1.0]
var liver_opacity_index := 1


func toggle_liver() -> void:
    liver.visible = not liver.visible


func toggle_mass() -> void:
    mass.visible = not mass.visible


func toggle_portal_vein() -> void:
    portal_vein.visible = not portal_vein.visible


func toggle_abdominal_aorta() -> void:
    abdominal_aorta.visible = not abdominal_aorta.visible


func rotate_left() -> void:
    patient_pivot.rotate_y(deg_to_rad(15.0))


func rotate_right() -> void:
    patient_pivot.rotate_y(deg_to_rad(-15.0))


func reset_view() -> void:
    patient_pivot.rotation = Vector3.ZERO


func cycle_liver_opacity() -> void:
    liver_opacity_index = (liver_opacity_index + 1) % liver_opacity_levels.size()
    set_liver_opacity(liver_opacity_levels[liver_opacity_index])


func set_liver_opacity(alpha: float) -> void:
    _set_node_alpha(liver, alpha)


func _set_node_alpha(node: Node, alpha: float) -> void:
    if node is MeshInstance3D:
        var mesh_instance := node as MeshInstance3D

        for i in range(mesh_instance.get_surface_override_material_count()):
            var mat := mesh_instance.get_surface_override_material(i)

            if mat == null:
                mat = mesh_instance.get_active_material(i)

            if mat != null and mat is StandardMaterial3D:
                var new_mat := mat.duplicate() as StandardMaterial3D
                new_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
                new_mat.albedo_color.a = alpha
                mesh_instance.set_surface_override_material(i, new_mat)

    for child in node.get_children():
        _set_node_alpha(child, alpha)

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("ui_accept"):
        toggle_liver()

    if event is InputEventKey and event.pressed:
        match event.keycode:
            KEY_1:
                toggle_liver()
            KEY_2:
                toggle_mass()
            KEY_3:
                toggle_portal_vein()
            KEY_4:
                toggle_abdominal_aorta()
            KEY_5:
                cycle_liver_opacity()
            KEY_Q:
                rotate_left()
            KEY_E:
                rotate_right()
            KEY_R:
                reset_view()
