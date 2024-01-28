class_name FrictionThrowableObjectMovement
extends ThrowableObjectMovement


func _get_next_velocity(_velocityOwner: CharacterBody2D) -> Vector2:
  #return speed * direction * velocityOwner.get_physics_process_delta_time()
  #return _velocity.move_toward(direction, speed * velocityOwner.get_physics_process_delta_time())
  #print('DBG: aaa friction %s %s %s %s %s' % [_velocityOwner.velocity, direction, speed, speed * _current_delta, _velocityOwner.velocity.move_toward(direction, speed * _current_delta)])
  #print('DBG: aaa friction %s %s %s %s %s' % [_velocityOwner.velocity, direction, speed, speed, _velocityOwner.velocity.move_toward(direction, speed * _current_delta)])
  return _velocityOwner.velocity.move_toward(direction, speed)


func _use_set_velocity() -> bool:
  return true
