extends XRController3D

@onready var ray: RayCast3D = $TeleportRay
@onready var marker: MeshInstance3D = $TeleportMarker

@onready var xr_origin: XROrigin3D = get_parent() as XROrigin3D
@onready var xr_camera: XRCamera3D = xr_origin.get_node("XRCamera3D") as XRCamera3D
@onready var player: CharacterBody3D = xr_origin.get_parent() as CharacterBody3D


func _ready() -> void:
    marker.visible = false


func _process(_delta: float) -> void:
    if not ray.is_colliding():
        marker.visible = false
        return

    var collider := ray.get_collider()

    if collider != null and collider.has_method("press"):
        marker.visible = false
        return

    marker.global_position = ray.get_collision_point()
    marker.visible = true


func try_press_ui_button() -> bool:
    if not ray.is_colliding():
        return false

    var collider := ray.get_collider()

    if collider == null:
        return false

    print("RightController ray hit: ", collider.name)

    if collider.has_method("press"):
        collider.press()
        return true

    return false


func teleport_now() -> void:
    if not ray.is_colliding():
        return

    if player == null:
        push_warning("Teleport: player is null (XROrigin3D nie jest dzieckiem CharacterBody3D).")
        return

    var target_point: Vector3 = ray.get_collision_point()

    var origin_pos := xr_origin.global_position
    var cam_pos := xr_camera.global_position
    var offset_x := cam_pos.x - origin_pos.x
    var offset_z := cam_pos.z - origin_pos.z

    var new_player_pos := Vector3(
        target_point.x - offset_x,
        target_point.y,
        target_point.z - offset_z
    )

    player.global_position = new_player_pos


func _on_right_controller_button_released(button_name: String) -> void:
    print("Puszczono przycisk: ", button_name)

    if button_name == "trigger_click":
        if try_press_ui_button():
            print("Pressed UI button with right controller")
            return

        teleport_now()
