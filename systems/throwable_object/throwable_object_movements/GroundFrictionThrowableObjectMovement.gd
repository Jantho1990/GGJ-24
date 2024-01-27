class_name GroundFrictionThrowableObjectMovement
extends FrictionThrowableObjectMovement


var _velocityOwner

func _get_next_velocity(velocityOwner: CharacterBody2D) -> Vector2:
  _velocityOwner = velocityOwner
  if not velocityOwner.is_on_floor():
    return Vector2.ZERO
  return super(velocityOwner)


func _use_set_velocity() -> bool:
  return _velocityOwner and _velocityOwner.is_on_floor()
