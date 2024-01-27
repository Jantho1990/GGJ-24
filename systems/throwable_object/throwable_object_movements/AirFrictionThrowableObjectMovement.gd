class_name AirFrictionThrowableObjectMovement
extends FrictionThrowableObjectMovement


func _get_next_velocity(velocityOwner: CharacterBody2D) -> Vector2:
  if velocityOwner.is_on_floor():
    return Vector2.ZERO
  return super(velocityOwner)
