extends RigidBody3D

# Globals ig?
var mouse_sensitivity := 0.001
var twist_input := 0.0
var pitch_input := 0.0

@onready var twist_pivot := get_node("TwistPivot")
@onready var pitch_pivot := get_node("TwistPivot/PitchPivot")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  cursor_mode["lock"].call()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  cursor_mode["free"].call()
  char_movement(delta)
  char_camera()

func _unhandled_input(event: InputEvent) -> void:
  if event is InputEventMouseMotion:
    if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
      twist_input = -event.relative.x * mouse_sensitivity
      pitch_input = -event.relative.y * mouse_sensitivity

func char_movement(delta: float, multiplier: float=1200.0) -> void:
  var input := Vector3.ZERO

  input.x = Input.get_axis("move-left", "move-right")
  input.z = Input.get_axis("move-forward", "move-back")
  apply_central_force(twist_pivot.basis * input * multiplier * delta)

func char_camera() -> void:
  twist_pivot.rotate_y(twist_input)
  pitch_pivot.rotate_x(pitch_input)
  pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad( - 15), deg_to_rad(30))

  twist_input = 0.0
  pitch_input = 0.0

var cursor_mode := {
  "free": func() -> void:
    if Input.is_action_just_pressed("ui_cancel"):
      Input.mouse_mode = Input.MOUSE_MODE_VISIBLE,
  "lock": func() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED,
}