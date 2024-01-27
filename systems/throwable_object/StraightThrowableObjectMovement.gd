class_name StraightThrowableObjectMovement
extends ThrowableObjectMovement


func _get_next_velocity(velocityOwner: CharacterBody2D) -> Vector2:
  return speed * direction * velocityOwner.get_physics_process_delta_time()
