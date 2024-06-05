extends CharacterBody3D

const SPEED = 7.0
const JUMP_VELOCITY = 4.5

var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var twist_pivot := get_node("TwistPivot")
@onready var pitch_pivot := get_node("TwistPivot/PitchPivot")

func _ready() -> void:
    cursor_mode["lock"].call()

# -------------------

func _physics_process(delta: float) -> void:
    cursor_mode["free"].call()
    char_movement(delta)
    char_camera()

# -------------------

func _unhandled_input(event: InputEvent) -> void:
  if event is InputEventMouseMotion:
    if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
      twist_input = -event.relative.x * mouse_sensitivity
      pitch_input = -event.relative.y * mouse_sensitivity

# -------------------

func char_movement(delta: float) -> void:
    # Add the gravity.
    if not is_on_floor():
        velocity.y -= gravity * delta

    # Handle jump.
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = JUMP_VELOCITY

    # Get the input direction and handle the movement/deceleration.
    var input := Vector3.ZERO
    input.x = Input.get_axis("move-left", "move-right")
    input.z = Input.get_axis("move-forward", "move-back")

    var direction = twist_pivot.basis * input
    if direction:
        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)

    move_and_slide()

# -------------------

func char_camera() -> void:
  twist_pivot.rotate_y(twist_input)
  pitch_pivot.rotate_x(pitch_input)
  pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad( - 15), deg_to_rad(30))

  twist_input = 0.0
  pitch_input = 0.0

# -------------------

var cursor_mode := {
  "free": func() -> void:
    if Input.is_action_just_pressed("ui_cancel"):
      Input.mouse_mode = Input.MOUSE_MODE_VISIBLE,
  "lock": func() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED,
}
