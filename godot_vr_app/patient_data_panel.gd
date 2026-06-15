extends Node3D


@export var label_font_size: int = 36
@export var title_font_size: int = 44

@export var legend_start_y: float = 0.0
@export var summary_start_y: float = -0.55

@export var row_spacing: float = 0.13
@export var text_x: float = 0.10
@export var color_box_x: float = -0.22


func _ready() -> void:
    create_structure_legend()
    create_quantitative_summary()


func create_structure_legend() -> void:
    var title := create_label(
        "Structure Legend",
        Vector3(-0.25, legend_start_y, 0.01),
        title_font_size
    )
    add_child(title)

    var legend_items := [
        {
            "name": "Liver",
            "color": Color(1.0, 0.25, 0.15, 1.0)
        },
        {
            "name": "Mass segment",
            "color": Color(0.1, 1.0, 0.2, 1.0)
        },
        {
            "name": "Portal vein",
            "color": Color(1.0, 0.9, 0.1, 1.0)
        },
        {
            "name": "Abdominal aorta",
            "color": Color(0.0, 0.85, 1.0, 1.0)
        }
    ]

    for i in range(legend_items.size()):
        var item = legend_items[i]
        var y := legend_start_y - 0.16 - float(i) * row_spacing

        var box := create_color_box(item["color"], Vector3(color_box_x, y, 0.01))
        add_child(box)

        var label := create_label(
            item["name"],
            Vector3(text_x, y - 0.005, 0.01),
            label_font_size
        )
        add_child(label)


func create_quantitative_summary() -> void:
    var title := create_label(
        "Quantitative Summary",
        Vector3(-0.25, summary_start_y, 0.01),
        title_font_size
    )
    add_child(title)

    var summary_text := (
		"Structure        Volume [cm3]   Mean HU\n"
        + "Liver              1441.6        95.8\n"
        + "Mass segment       1470.9        110.9\n"
        + "Portal vein        14.6          182.6\n"
        + "Abdominal aorta    5.2           169.9"
    )

    var summary_label := create_label(
        summary_text,
        Vector3(-0.25, summary_start_y - 0.18, 0.01),
        28
    )
    summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
    add_child(summary_label)


func create_label(text: String, position: Vector3, font_size: int) -> Label3D:
    var label := Label3D.new()
    label.text = text
    label.position = position
    label.font_size = font_size
    label.modulate = Color(0.85, 0.95, 1.0, 1.0)
    label.outline_size = 4
    label.outline_modulate = Color(0.0, 0.0, 0.0, 1.0)
    label.billboard = BaseMaterial3D.BILLBOARD_DISABLED
    return label


func create_color_box(color: Color, position: Vector3) -> MeshInstance3D:
    var box := MeshInstance3D.new()

    var mesh := BoxMesh.new()
    mesh.size = Vector3(0.055, 0.055, 0.01)
    box.mesh = mesh
    box.position = position

    var mat := StandardMaterial3D.new()
    mat.albedo_color = color
    mat.emission_enabled = true
    mat.emission = color
    mat.emission_energy_multiplier = 0.4

    box.material_override = mat

    return box
