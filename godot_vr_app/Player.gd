extends CharacterBody3D

@export var move_speed: float = 2.0
@export var gravity: float = 9.8
@export var deadzone: float = 0.15

@export var snap_turn_angle := 45.0        # stopnie
@export var snap_turn_deadzone := 0.7

# Reset na spawn (lewy spust)
@export var reset_button_name: String = "trigger_click"  # zmień jeśli konsola pokaże inną nazwę

var snap_turn_ready := true

@onready var xr_origin: XROrigin3D = $XROrigin3D
@onready var xr_camera: XRCamera3D = $XROrigin3D/XRCamera3D
@onready var left_controller: XRController3D = $XROrigin3D/LeftController
@onready var right_controller: XRController3D = $XROrigin3D/RightController

var _spawn_pos: Vector3
var _spawn_yaw: float


func _ready() -> void:
	# Zapamiętaj spawn jako startową pozycję Playera
	_spawn_pos = global_position
	_spawn_yaw = global_rotation.y

	# Podepnij sygnał z lewego kontrolera (reset)
	if left_controller and not left_controller.button_released.is_connected(_on_left_controller_button_released):
		left_controller.button_released.connect(_on_left_controller_button_released)


func _physics_process(delta: float) -> void:
	# --- grawitacja ---
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = -0.1

	# --- gałka (z fallback) ---
	var stick := _get_left_stick()

	if stick.length() < deadzone:
		stick = Vector2.ZERO

	# --- kierunek względem kamery ---
	var cam_basis: Basis = xr_camera.global_transform.basis
	var forward: Vector3 = -cam_basis.z
	var right: Vector3 = cam_basis.x
	forward.y = 0.0
	right.y = 0.0
	forward = forward.normalized()
	right = right.normalized()

	# stick.y zwykle u góry = -1
	var move_dir: Vector3 = (right * stick.x) + (forward * (stick.y))

	if move_dir.length() > 0.0:
		move_dir = move_dir.normalized()
		velocity.x = move_dir.x * move_speed
		velocity.z = move_dir.z * move_speed
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	move_and_slide()
	_handle_snap_turn()


func _get_left_stick() -> Vector2:
	# Najczęściej działa:
	var v := left_controller.get_vector2("thumbstick")
	if v != Vector2.ZERO:
		return v

	# Czasem w WebXR/konfiguracjach:
	v = left_controller.get_vector2("primary")
	if v != Vector2.ZERO:
		return v

	v = left_controller.get_vector2("trackpad")
	return v


func _get_right_stick() -> Vector2:
	var v := right_controller.get_vector2("thumbstick")
	if v != Vector2.ZERO:
		return v

	v = right_controller.get_vector2("primary")
	if v != Vector2.ZERO:
		return v

	return right_controller.get_vector2("trackpad")


func _handle_snap_turn() -> void:
	var stick := _get_right_stick()

	# jeśli gałka wróciła do środka → odblokuj snap
	if abs(stick.x) < 0.2:
		snap_turn_ready = true
		return

	if not snap_turn_ready:
		return

	if stick.x > snap_turn_deadzone:
		rotate_y(deg_to_rad(-snap_turn_angle))
		snap_turn_ready = false

	elif stick.x < -snap_turn_deadzone:
		rotate_y(deg_to_rad(snap_turn_angle))
		snap_turn_ready = false


# =========================
# RESET NA SPAWN (LEFT TRIGGER)
# =========================

func _on_left_controller_button_released(button_name: String) -> void:
	print("LEFT released: ", button_name)
	if button_name == reset_button_name:
		reset_to_spawn()


func reset_to_spawn() -> void:
	# Ustawiamy Playera tak, by HMD (kamera) wróciła na spawn w osi XZ
	var origin_pos := xr_origin.global_position
	var cam_pos := xr_camera.global_position

	var offset_x := cam_pos.x - origin_pos.x
	var offset_z := cam_pos.z - origin_pos.z

	global_position = Vector3(
		_spawn_pos.x - offset_x,
		_spawn_pos.y,
		_spawn_pos.z - offset_z
	)

	# Opcjonalnie: przywróć obrót (yaw) na startowy
	var r := global_rotation
	r.y = _spawn_yaw
	global_rotation = r

	# Wyzeruj prędkość, żeby po resecie nie "ciągnęło" dalej
	velocity = Vector3.ZERO
