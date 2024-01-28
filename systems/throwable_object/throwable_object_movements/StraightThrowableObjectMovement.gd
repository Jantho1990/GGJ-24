class_name StraightThrowableObjectMovement
extends ThrowableObjectMovement


var _accel := Vector2.ZERO

func _get_next_velocity(velocityOwner: CharacterBody2D) -> Vector2:
  var speed_vec = speed * direction + _accel # Gravity overwhelms this, how do we counter? Track accel separately?
  #var speed_vec = speed * direction.rotated(velocityOwner.rotation) + _accel # Gravity overwhelms this, how do we counter? Track accel separately?
  var max_vec = max_speed * direction
  _accel = speed_vec if max_vec.length() > speed_vec.length() else max_vec
  return _accel


func reset() -> void:
  super()
  _accel = Vector2.ZERO
