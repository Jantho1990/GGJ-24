# This class might be redundant with Straight, but feels like we want something separate that is called Gravity.
# Might refactor later.
class_name GravityThrowableObjectMovement
extends ThrowableObjectMovement


func _get_next_velocity(_velocityOwner: CharacterBody2D) -> Vector2:
  return speed * Vector2.DOWN + _velocity
