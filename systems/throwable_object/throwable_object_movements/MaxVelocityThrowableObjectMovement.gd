class_name MaxVelocityThrowableObjectMovement
extends ThrowableObjectMovement


func _get_next_velocity(velocityOwner: CharacterBody2D) -> Vector2:
  var max_len = (speed * direction).length()
  var limited_velocity = velocityOwner.velocity.limit_length(max_len)
  return limited_velocity


func _use_set_velocity() -> bool:
  return true
