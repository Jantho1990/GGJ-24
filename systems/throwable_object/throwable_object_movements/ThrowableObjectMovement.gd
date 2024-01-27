class_name ThrowableObjectMovement
extends Resource

@export var speed := 300.0
@export var max_speed := 300.0
@export var direction = Vector2.RIGHT
@export var duration := -1.0 # -1.0 is infinite, otherwise will expire the movement after specified amount (in seconds)

var _allow_processing := true
var _current_duration := 0.0
var _velocity := Vector2.ZERO


func _process_duration(delta: float) -> void:
  if duration == -1.0:
    return
  _current_duration += delta
  if _current_duration > duration:
    _allow_processing = false


func integrate_velocity(velocityOwner: CharacterBody2D) -> void:
  if not _allow_processing:
    return
  
  _velocity = Vector2.ZERO
  if _use_set_velocity():
    _velocity = _get_next_velocity(velocityOwner)
    velocityOwner.velocity = _velocity
    #print('DBG: setting %s velocity' % [_velocity])
  else:
    _velocity += _get_next_velocity(velocityOwner)
    velocityOwner.velocity += _velocity
    #print('DBG: adding %s velocity' % [_velocity])
    
  #if velocityOwner is ThrowableObject:
  _process_duration(velocityOwner.get_physics_process_delta_time())


func _get_next_velocity(_velocityOwner: CharacterBody2D) -> Vector2:
  assert(false, 'ThrowableObjectMovement._get_next_velocity(): Using base class, extend ThrowableObjectMovement and inherit the _get_next_velocity function.')
  return Vector2.ZERO


func _set_next_velocity(_velocityOwner: CharacterBody2D) -> void:
  assert(false, 'ThrowableObjectMovement._set_next_velocity(): Using base class, extend ThrowableObjectMovement and inherit the _set_next_velocity function.')


func _use_set_velocity() -> bool:
  return false


func reset() -> void:
  _current_duration = 0.0
