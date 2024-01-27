class_name SineThrowableObjectMovement
extends ThrowableObjectMovement


func _get_next_velocity(velocityOwner: CharacterBody2D) -> Vector2:
  return speed * direction * sin(velocityOwner.get_physics_process_delta_time())
