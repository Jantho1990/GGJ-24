class_name GroundFrictionThrowableObjectMovement
extends FrictionThrowableObjectMovement


func _get_next_velocity(velocityOwner: CharacterBody2D) -> Vector2:
  if not velocityOwner.is_on_floor():
    return Vector2.ZERO
  return super(velocityOwner)
