class_name ThrowableObject
extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var movements : Array[ThrowableObjectMovement] = []


func _physics_process(delta: float) -> void:
  for throwableObjectMovement in movements:
    throwableObjectMovement.integrate_velocity(self)
  
  move_and_slide()


func _old_physics_process(delta):
  # Add the gravity.
  if not is_on_floor():
    velocity.y += 98.0 * delta

  # Handle jump.
  if Input.is_action_just_pressed("ui_accept") and is_on_floor():
    velocity.y = JUMP_VELOCITY

  # Get the input direction and handle the movement/deceleration.
  # As good practice, you should replace UI actions with custom gameplay actions.
  var direction = Input.get_axis("ui_left", "ui_right")
  if direction:
    velocity.x = direction * SPEED
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)

  move_and_slide()
