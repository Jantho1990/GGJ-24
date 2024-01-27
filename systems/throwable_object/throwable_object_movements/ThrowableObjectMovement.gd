class_name ThrowableObjectMovement
extends Resource

@export var speed := 300.0
@export var max_speed := 300.0
@export var direction = Vector2.RIGHT

var _velocity := Vector2.ZERO

func integrate_velocity(velocityOwner: CharacterBody2D) -> void:
  _velocity = Vector2.ZERO
  if _use_set_velocity():
    _velocity = _get_next_velocity(velocityOwner)
    velocityOwner.velocity = _velocity
    print('DBG: setting %s velocity' % [_velocity])
  else:
    _velocity += _get_next_velocity(velocityOwner)
    velocityOwner.velocity += _velocity
    print('DBG: adding %s velocity' % [_velocity])


func _get_next_velocity(_velocityOwner: CharacterBody2D) -> Vector2:
  assert(false, 'ThrowableObjectMovement._get_next_velocity(): Using base class, extend ThrowableObjectMovement and inherit the _get_next_velocity function.')
  return Vector2.ZERO


func _set_next_velocity(_velocityOwner: CharacterBody2D) -> void:
  assert(false, 'ThrowableObjectMovement._set_next_velocity(): Using base class, extend ThrowableObjectMovement and inherit the _set_next_velocity function.')


func _use_set_velocity() -> bool:
  return false
